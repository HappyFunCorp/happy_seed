module HappySeed
  module Generators
    class BaseGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_foreman
        puts "Installing happy_seed:base environment"
        gem 'dotenv-rails', :groups=>[:development, :test]
        gem 'rdiscount', :groups => [:development, :test]
        gem 'unicorn'
        gem 'rails_12factor'

        Bundler.with_clean_env do
          run "bundle install > /dev/null"
        end

        directory '.'

        remove_file "application_controller.rb"

        inject_into_file 'app/controllers/application_controller.rb', File.read( find_in_source_paths('application_controller.rb') ), :after=>/protect_from_forgery.*\n/
        inject_into_file 'config/environments/test.rb', "  config.log_level = :error\n", before: "end\n"

        begin
          inject_into_file 'spec/spec_helper.rb', "\n  config.include Warden::Test::Helpers, type: :feature\n  config.include ControllerHelpers, type: :controller\n  Warden.test_mode!\n", :before => "\nend\n"
          prepend_to_file 'spec/spec_helper.rb', "require_relative 'support/controller_helpers'\n"
        rescue
          say_status :spec, "Unable to add login helpers to spec_helper.rb"
        end


        begin
          inject_into_file 'spec/rails_helper.rb', "require 'webmock/rspec'\n", after: "'rspec/rails'\n"
        rescue
          say_status :spec, "Unable to add webmock to rails_helper.rb", :red
        end

        begin
          inject_into_file 'spec/rails_helper.rb', "\n  config.include FactoryGirl::Syntax::Methods\n", :before => "\nend\n"
          append_to_file 'spec/rails_helper.rb', "\nVCR.configure do |c|\n  c.cassette_library_dir  = Rails.root.join('spec', 'vcr')\n  c.hook_into :webmock\nend\n"
        rescue
          say_status :spec, "Unable to add factory girl and VCR to rails_helper.rb", :red
        end

        route "get '/setup' => 'setup#index'"
        route "root 'setup#index'"
      end
    end
  end
end

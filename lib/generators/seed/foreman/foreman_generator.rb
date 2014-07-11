module Seed
  module Generators
    class ForemanGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_foreman
        gem 'dotenv-rails', :groups=>[:development, :test]
        gem 'rdiscount', :groups => [:development]
        gem 'unicorn'
        gem 'rails_12factor'

        Bundler.with_clean_env do
          run "bundle install"
        end

        directory '.'

        remove_file "application_controller.rb"

        inject_into_file 'app/controllers/application_controller.rb', File.read( find_in_source_paths('application_controller.rb') ), :after=>/protect_from_forgery.*\n/

        route "get '/setup' => 'setup#index'"
        route "root 'setup#index'"
      end
    end
  end
end
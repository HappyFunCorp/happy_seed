require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/bootstrap/bootstrap_generator'

module HappySeed
  module Generators
    class DeviseGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'devise'
      end

      def install_devise
        return if already_installed

        require_generator BootstrapGenerator

        gem 'devise', '~> 3.4'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        run 'bin/spring stop'

        puts "Devise: #{self.class.fingerprint}"

        Bundler.with_clean_env do
          run 'rails generate devise:install'
          run 'rails generate devise User'
          run 'rails generate devise:views'
        end
                
        if gem_available?( "haml-rails" )
          remove_file 'app/views/devise/registrations/new.html.erb'
          remove_file 'app/views/devise/registrations/edit.html.erb'
          remove_file 'app/views/devise/sessions/new.html.erb'
          remove_file 'app/views/devise/passwords/edit.html.erb'
          remove_file 'app/views/devise/passwords/new.html.erb'
        end

        remove_file "spec/factories/users.rb"
        
        begin
          prepend_to_file 'spec/spec_helper.rb', "require 'devise'\n"
          prepend_to_file 'spec/spec_helper.rb', "require_relative 'support/controller_helpers'\n"
          inject_into_file 'spec/spec_helper.rb', "\n  config.include Devise::TestHelpers, type: :controller\n", :before => "\nend\n"
          inject_into_file 'spec/spec_helper.rb', "\n  config.include Warden::Test::Helpers, type: :feature\n  config.include ControllerHelpers, type: :controller\n  Warden.test_mode!\n", :before => "\nend\n"
        rescue
          say_status :spec, "Unable to add devise helpers to spec_helper.rb", :red
        end

        begin
          inject_into_file 'spec/rails_helper.rb', "\n  config.include Devise::TestHelpers, type: :controller\n  config.include Warden::Test::Helpers, type: :feature\n", :after => "FactoryGirl::Syntax::Methods\n"
        rescue
          say_status :spec, "Unable to add devise helpers to rails_helper.rb", :red
        end

        append_to_file "features/support/env.rb", "
Warden.test_mode! 
World(Warden::Test::Helpers)
After{ Warden.test_reset! }"

        directory 'app'
        directory 'docs'
        directory 'test'
        directory 'spec'

        application(nil, env: "development") do
          "config.action_mailer.default_url_options = { host: 'localhost:3000' }"
        end

        application(nil, env: "test") do
          "config.action_mailer.default_url_options = { host: 'localhost:3000' }"
        end

        if File.exists?( File.join( destination_root, 'app/views/application/_header.html.haml' ) )
          gsub_file 'app/views/application/_header.html.haml', "/ USER NAV", '= render partial: "application/account_dropdown"'
        else
          say_status :gsub_file, "Can't find application/_header.html.haml, skipping"
        end
      end

      private
        def gem_available?(name)
          Gem::Specification.find_by_name(name)
        rescue Gem::LoadError
          false
        rescue
          Gem.available?(name)
        end

    end
  end
end
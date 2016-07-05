require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/bootstrap/bootstrap_generator'
require 'generators/happy_seed/html_email/html_email_generator'

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
        require_generator HtmlEmailGenerator

        gem 'devise', '~> 4.2'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        run 'bin/spring stop'

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

        remove_file 'app/views/devise/mailer/reset_password_instructions.html.erb'
        remove_file 'app/views/devise/mailer/confirmation_instructions.html.erb'
        
        remove_file "spec/factories/users.rb"
        
        begin
          prepend_to_file 'spec/spec_helper.rb', "require 'devise'\n"
        rescue
          say_status :spec, "Unable to add devise helpers to spec_helper.rb", :red
        end

        directory 'app'
        directory 'docs'
        # directory 'test'
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

        gsub_file "config/initializers/devise.rb", "# config.parent_mailer = 'ActionMailer::Base'", "config.parent_mailer = 'ApplicationMailer'"

        gsub_file 'config/routes.rb', "devise_for :users", "devise_for :users, :controllers => { }"
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
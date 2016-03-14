require 'generators/happy_seed/devise/devise_generator'

module HappySeed
  module Generators
    class DeviseConfirmableGenerator < HappySeedGenerator
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        # gem_available? 'devise_invitable'
      end

      def install_device_invitable
        # return if already_installed

        require_generator DeviseGenerator

        gsub_file "app/models/user.rb", "devise :", "devise :confirmable, :"

        migration_template("add_confirmable_to_devise.rb", "db/migrate/add_confirmable_to_devise.rb" )

        # gem 'devise_invitable', github: "scambra/devise_invitable"

        # Bundler.with_clean_env do
        #   run "bundle install --without production"
        #   run 'rake db:migrate'
        # end

        # run 'rails generate devise_invitable:install'
        # run 'rails generate devise_invitable User'
        # run 'rails generate devise_invitable:views'

        # remove_file 'app/views/devise/mailer/invitation_instructions.html.erb'
        
        directory 'app'
        directory 'docs'
        directory 'spec'

        gsub_file 'config/routes.rb', "devise_for :users, :controllers => {", "devise_for :users, :controllers => { confirmations: 'confirmations', "
        # if gem_available?( "haml-rails" )
        #   remove_file 'app/views/devise/invitations/new.html.erb'
        #   remove_file 'app/views/devise/invitations/edit.html.erb'
        # end
      end

      private
        def gem_available?(name)
          Gem::Specification.find_by_name(name)
        rescue Gem::LoadError
          false
        rescue
          Gem.available?(name)
        end

        def self.next_migration_number(dir)
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        end

    end
  end
end
require 'generators/happy_seed/omniauth/omniauth_generator'

module HappySeed
  module Generators
    class GoogleoauthGenerator < HappySeedGenerator
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'omniauth-google-oauth2'
      end

      def install_facebook
        return if already_installed

        require_generator OmniauthGenerator

        gem 'omniauth-google-oauth2'
        gem 'google-api-client', require: "google/api_client"

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        directory 'docs'
        directory 'app'

        add_omniauth :google_oauth2, 'email,profile,offline", prompt: "consent', 'GoogleAppsClient', "google_oauth2"
        insert_into_file "app/models/identity.rb", "\n      identity.refreshtoken = auth.credentials.refresh_token", after: "identity.accesstoken = auth.credentials.token"
        migration_template("add_refresh_token_to_identity.rb", "db/migrate/add_refresh_token_to_identity.rb" )
      end

      protected
        def self.next_migration_number(dir)
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        end

    end
  end
end
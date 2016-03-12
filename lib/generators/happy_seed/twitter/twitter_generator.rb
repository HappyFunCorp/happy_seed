require 'generators/happy_seed/omniauth/omniauth_generator'

module HappySeed
  module Generators
    class TwitterGenerator < HappySeedGenerator
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available?( 'omniauth-twitter' )
      end

      def install_twitter
        return if already_installed

        require_generator OmniauthGenerator

        gem 'omniauth-twitter'
        gem 'twitter'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        add_omniauth :twitter

        directory "docs"
        directory "spec"
        insert_into_file "app/models/identity.rb", "      identity.secrettoken = auth.credentials.secret\n", after: "identity.accesstoken = auth.credentials.token\n"
        migration_template("add_secret_token_to_identity.rb", "db/migrate/add_secret_token_to_identity.rb" )

        gsub_file( "app/models/user.rb", "Twitter.client( access_token: twitter.accesstoken )",
    "Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_APP_ID']
      config.consumer_secret     = ENV['TWITTER_APP_SECRET']
      config.access_token        = twitter.accesstoken
      config.access_token_secret = twitter.secrettoken
    end")
      end

      protected

      def self.next_migration_number(dir)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end

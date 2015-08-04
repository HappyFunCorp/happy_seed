require 'generators/happy_seed/bootstrap/bootstrap_generator'

module HappySeed
  module Generators
    class SplashGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        File.exists?( "docs/README.02.splash.rdoc" )
      end

      def install_landing_page
        return if already_installed

        require_generator BootstrapGenerator

        gem 'gibbon'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        remove_file 'public/index.html'

        gsub_file "config/routes.rb", /\s*root.*\n/, "\n"
        route "root 'splash#index'"
        route "get '/splash' => 'splash#index'"
        route "post '/signup' => 'splash#signup', as: :splash_signup"

        directory 'app'
        directory "docs"
        directory "spec"
      	directory "vendor"

        append_to_file "config/initializers/assets.rb", "Rails.application.config.assets.precompile += %w( splash.css scrollReveal.js )\n"

        begin
          add_env "MAILCHIMP_API_KEY"
          add_env "MAILCHIMP_SPLASH_SIGNUP_LIST_ID"
        rescue
          say_status :env, "Unable to add template .env files", :red
        end
      end
    end
  end
end

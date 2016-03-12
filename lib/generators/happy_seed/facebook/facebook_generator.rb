require 'generators/happy_seed/omniauth/omniauth_generator'
require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class FacebookGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'omniauth-facebook'
      end

      def install_facebook
        return if already_installed

        require_generator OmniauthGenerator

        gem 'omniauth-facebook'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        directory 'docs'
        directory 'spec'


        add_omniauth :facebook, "email"
      end
    end
  end
end
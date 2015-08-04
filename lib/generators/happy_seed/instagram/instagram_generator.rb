require 'generators/happy_seed/omniauth/omniauth_generator'

module HappySeed
  module Generators
    class InstagramGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'omniauth-instagram'
      end

      def install_instagram
        return if already_installed

        require_generator OmniauthGenerator

        gem 'omniauth-instagram'
        gem 'instagram'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        directory "docs"

        add_omniauth :instagram
      end
    end
  end
end
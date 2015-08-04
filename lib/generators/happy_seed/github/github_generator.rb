require 'generators/happy_seed/omniauth/omniauth_generator'

module HappySeed
  module Generators
    class GithubGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'omniauth-github'
      end

      def install_github
        return if already_installed

        require_generator OmniauthGenerator

        gem 'omniauth-github'
        gem 'github_api'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        directory 'docs'

        add_omniauth :github, "user", "Github"
      end
    end
  end
end
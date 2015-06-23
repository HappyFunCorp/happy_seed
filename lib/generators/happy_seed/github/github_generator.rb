require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class GithubGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def install_github
        require_omniauth

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
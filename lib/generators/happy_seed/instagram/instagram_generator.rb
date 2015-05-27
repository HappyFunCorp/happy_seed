require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class InstagramGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def install_instagram
        require_omniauth

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
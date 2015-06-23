require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class TwitterGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def install_twitter
        require_omniauth

        gem 'omniauth-twitter'
        gem 'twitter'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        add_omniauth :twitter

        directory "docs"
      end
    end
  end
end

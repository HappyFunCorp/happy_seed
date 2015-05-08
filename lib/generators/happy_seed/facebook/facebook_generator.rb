require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class FacebookGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def install_facebook
        require_omniauth

        gem 'omniauth-facebook'

        Bundler.with_clean_env do
          run "bundle install > /dev/null"
        end

        directory 'docs'

        add_omniauth :facebook, "email"
      end
    end
  end
end
require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class FacebookGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def install_facebook
        require_omniauth

        gem 'omniauth-facebook'

        Bundler.with_clean_env do
          run "bundle install"
        end

        directory 'docs'

        add_omniauth :facebook, "offline_access,read_insights,manage_pages"
      end
    end
  end
end
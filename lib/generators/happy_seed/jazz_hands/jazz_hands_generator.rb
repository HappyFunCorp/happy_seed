module HappySeed
  module Generators
    class JazzHandsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_jazz_hands

        gem 'jazz_hands', :groups => [:development, :test]

        Bundler.with_clean_env do
          run "bundle install"
        end

      end

    end
  end
end

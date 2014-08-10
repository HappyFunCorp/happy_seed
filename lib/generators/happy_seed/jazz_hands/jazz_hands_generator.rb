module HappySeed
  module Generators
    class JazzHandsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_jazz_hands

        gem 'jazz_hands', :github => 'nixme/jazz_hands', :branch => 'bring-your-own-debugger', :groups => [:development, :test]

        ruby_major_version = RUBY_VERSION.split('.')[0]

        if ruby_major_version == '1'
          gem 'debugger', :groups => [:development, :test]
        else
          gem 'byebug', :groups => [:development, :test]
        end

        inside 'config/initializers' do
          copy_file 'jazz_hands.rb'
        end

        Bundler.with_clean_env do
          run "bundle install"
        end

      end

    end
  end
end

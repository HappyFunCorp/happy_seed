module HappySeed
  module Generators
    class JazzHandsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_jazz_hands

        # gem 'jazz_hands', :github => 'nixme/jazz_hands', :branch => 'bring-your-own-debugger', :groups => [:development, :test]
        gem 'jazz_hands', :github => 'danrabinowitz/jazz_hands', :branch => 'use-newer-version-of-pry', :groups => [:development, :test]

        ruby_major_version = RUBY_VERSION.split('.')[0]

        inside 'config/initializers' do
          copy_file 'jazz_hands.rb'
        end

        Bundler.with_clean_env do
          run "bundle install > /dev/null"
        end
      end
    end
  end
end

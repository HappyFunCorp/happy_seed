require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class ReactGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available?( 'react_on_rails' )
      end

      def install_react
        return if already_installed

        gem 'react_on_rails'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        say_status :react, "Adding files to git", :green

        git add: "."
        git commit: "-a -m 'Adding react_on_rails'"

        generate 'react_on_rails:install'

        system "npm install"

        directory  "."

        say_status :react, "Now run: foreman start -f Procfile.dev", :green
      end
    end
  end
end

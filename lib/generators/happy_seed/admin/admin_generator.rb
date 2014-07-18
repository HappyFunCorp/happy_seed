module HappySeed
  module Generators
    class AdminGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        gem 'devise'
        gem 'activeadmin', github: 'gregbell/active_admin'

        Bundler.with_clean_env do
          run "bundle install"
        end

        generate 'active_admin:install'
        directory 'app'
        directory "docs"
      end

      private    
        def gem_available?(name)
           Gem::Specification.find_by_name(name)
        rescue Gem::LoadError
           false
        rescue
           Gem.available?(name)
        end
    end
  end
end

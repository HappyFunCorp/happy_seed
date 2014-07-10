module Seed
  module Generators
    class SplashGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        unless gem_available?( "bootstrap-sass" )
          puts "The splash generator requires bootstrap"

          if yes?( "Run seed:bootstrap now?" )
            generate "seed:bootstrap"
          else
            exit
          end
        end

        gem 'gibbon'

        run "bundle install"

        remove_file 'public/index.html'

        route "root 'splash#index'"
        route "post '/signup' => 'splash#signup', as: :splash_signup"

        directory 'app'
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
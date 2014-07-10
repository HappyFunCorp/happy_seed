module Seed
  module Generators
    class FacebookGenerator < Rails::Generators::Base
      # source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        unless gem_available?( "devise" )
          puts "The facebook generator requires devise"

          if yes?( "Run seed:devise now?" )
            generate "seed:devise"
          else
            exit
          end
        end

        unless File.exists? 'app/models/identity.rb'
          generate "seed:omniauth"
        end

        gem 'omniauth-facebook'

        run 'bundle install'

        inject_into_file 'config/initializers/devise.rb', after: "==> OmniAuth\n" do <<-'RUBY'
  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], scope: 'offline_access,read_insights,manage_pages'
RUBY
        end
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
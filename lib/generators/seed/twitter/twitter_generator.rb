module Seed
  module Generators
    class TwitterGenerator < Rails::Generators::Base
      # source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        unless gem_available?( "devise" )
          puts "The twitter generator requires devise"

          if yes?( "Run seed:devise now?" )
            generate "seed:devise"
          else
            exit
          end
        end

        unless File.exists? 'app/models/identity.rb'
          generate "seed:omniauth"
        end

        gem 'omniauth-twitter'

        run 'bundle install'

        inject_into_file 'config/initializers/devise.rb', after: "==> OmniAuth\n" do <<-'RUBY'
  config.omniauth :twitter, ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET']
RUBY
        end
        inject_into_file 'app/views/application/_header.html.haml', "          %li= link_to 'sign in with twitter', user_omniauth_authorize_path(:twitter)\n", after: "/ CONNECT\n"
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
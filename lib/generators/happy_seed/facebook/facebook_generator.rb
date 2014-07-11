module HappySeed
  module Generators
    class FacebookGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        unless gem_available?( "devise" )
          puts "The facebook generator requires devise"

          if yes?( "Run happy_seed:devise now?" )
            generate "happy_seed:devise"
          else
            exit
          end
        end

        unless File.exists? 'app/models/identity.rb'
          generate "happy_seed:omniauth"
        end

        gem 'omniauth-facebook'

        Bundler.with_clean_env do
          run "bundle install"
        end

        inject_into_file 'config/initializers/devise.rb', after: "==> OmniAuth\n" do <<-'RUBY'
  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], scope: 'offline_access,read_insights,manage_pages'
RUBY
        end

        append_to_file ".env", "FACEBOOK_APP_ID=\nFACEBOOK_APP_SECRET=\n"
        inject_into_file 'app/views/application/_header.html.haml', "          %li= link_to 'sign in with facebook', user_omniauth_authorize_path(:facebook)\n", after: "/ CONNECT\n"
        inject_into_file 'app/views/devise/sessions/new.html.haml', "                = link_to 'sign in with facebook', user_omniauth_authorize_path(:facebook)\n                %br\n", after: "/ CONNECT\n"
        inject_into_file 'app/views/devise/registrations/new.html.haml', "                = link_to 'sign in with facebook', user_omniauth_authorize_path(:facebook)\n                %br\n", after: "/ CONNECT\n"

        directory 'docs'
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
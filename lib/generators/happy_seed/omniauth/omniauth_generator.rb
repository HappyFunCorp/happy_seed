module HappySeed
  module Generators
    class OmniauthGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_omniauth
        # if File.exists? 'app/models/identity.rb'
        #   puts "identity.rb already exists, skipping"
        #   return
        # end

        unless gem_available?( "devise" )
          puts "The omniauth generator requires devise"

          if yes?( "Run happy_seed:devise now?" )
            generate "happy_seed:devise"
          else
            exit
          end
        end

        gem 'omniauth'

        Bundler.with_clean_env do
          run "bundle install"
        end

        generate 'model identity user:references provider:string accesstoken:string uid:string name:string email:string nickname:string image:string phone:string urls:string'
        remove_file 'app/models/identity.rb'
        remove_file 'spec/models/identity_spec.rb'
        directory 'app'
        directory 'spec'
        route "match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup"
        route "get '/account' => 'users#show', as: 'user'"

        begin
          gsub_file "app/models/user.rb", "devise :", "devise :omniauthable, :"
          insert_into_file "app/models/user.rb", File.read( find_in_source_paths( "user.rb" ) ), :before => "\nend\n"
        rescue
          say_status :user_model, "Unable to add omniauthable to app/models/users.rb", :red
        end

        begin
          insert_into_file "app/views/application/_header.html.haml", "            %li= link_to 'Account', user_path\n", after: "        - if user_signed_in?\n"
        rescue
          say_status :header_links, "Unable to add user accounts links to the nav bar", :red
        end

        gsub_file 'config/routes.rb', "devise_for :users\n", "devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }\n"

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
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

        generate 'migration add_name_to_users'

        puts Rails.root

        migration_file = (Dir.glob( File.join( Rails.root, "db/migrate/*add_name_to_users.rb" ) ).first || "").gsub( /.*db\/migrate/, "db/migrate" )
        remove_file migration_file
        
        copy_file "add_name_to_users.rb", migration_file

        generate 'model identity user:references provider:string uid:string'
        remove_file 'app/models/identity.rb'
        directory 'app'
        route "match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup"
        route "get '/account' => 'users#show', as: 'user'"

        gsub_file "app/models/user.rb", "devise :", "devise :omniauthable, :"
        insert_into_file "app/models/user.rb", File.read( find_in_source_paths( "user.rb" ) ), :before => "\nend\n"
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
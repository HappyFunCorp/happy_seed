module HappySeed
  module Generators
    class OmniauthGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def install_omniauth
        # if File.exists? 'app/models/identity.rb'
        #   puts "identity.rb already exists, skipping"
        #   return
        # end

        migration_template("make_email_nullable.rb", "db/migrate/make_email_nullable.rb" )

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
          run "bundle install --without production"
        end

        generate 'model identity user:references provider:string accesstoken:string uid:string name:string email:string nickname:string image:string phone:string urls:string'
        remove_file 'app/models/identity.rb'
        remove_file 'spec/models/identity_spec.rb'
        directory 'app'
        directory 'spec'
        # route "match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup"
        # route "get '/account' => 'users#show', as: 'user'"

        begin
          gsub_file "app/models/user.rb", "devise :", "devise :omniauthable, :"
          gsub_file "app/models/user.rb", ", :validatable", ""
          inject_into_class "app/models/user.rb", "User", "  has_many :identities, dependent: :destroy\n"
          # insert_into_file "app/models/user.rb", File.read( find_in_source_paths( "user.rb" ) ), :before => "\nend\n"
        rescue
          say_status :user_model, "Unable to add omniauthable to app/models/users.rb", :red
        end

        gsub_file 'config/routes.rb', "devise_for :users\n", "devise_for :users, class_name: 'FormUser', :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }\n"

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

        def self.next_migration_number(dir)
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        end
    end
  end
end
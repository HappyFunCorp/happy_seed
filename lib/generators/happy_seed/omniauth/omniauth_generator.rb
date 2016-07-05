require 'generators/happy_seed/devise/devise_generator'

module HappySeed
  module Generators
    class OmniauthGenerator < HappySeedGenerator
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available?( 'omniauth' )
      end

      def install_omniauth
        return if already_installed

        require_generator DeviseGenerator

        migration_template("make_email_nullable.rb", "db/migrate/make_email_nullable.rb" )

        gem 'omniauth'
        gem 'omniauth-oauth2', '1.3.1'

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
          inject_into_class "app/models/user.rb", "User", File.read( find_in_source_paths( "user.rb" ) )
        rescue
          say_status :user_model, "Unable to add omniauthable to app/models/users.rb", :red
        end

        gsub_file 'config/routes.rb', "devise_for :users, :controllers => {", "devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations', "

        directory "docs"
      end

      private
        def self.next_migration_number(dir)
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        end
    end
  end
end
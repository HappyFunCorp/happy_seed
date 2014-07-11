module Seed
  module Generators
    class OmniauthGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_omniauth
        if File.exists? 'app/models/identity.rb'
          puts "identity.rb already exists, skipping"
          return
        end

        unless gem_available?( "devise" )
          puts "The omniauth generator requires devise"

          if yes?( "Run seed:devise now?" )
            generate "seed:devise"
          else
            exit
          end
        end

        gem 'omniauth'

        Bundler.with_clean_env do
          run "bundle install"
        end

        generate 'model identity user:references provider:string uid:string'
        remove_file 'app/models/identity.rb'
        directory 'app'

        gsub_file "app/models/user.rb", "devise :", "devise :omniauthable, :"
        insert_into_file "app/models/user.rb", File.read( find_in_source_paths( "user.rb" ) ), :before => "\nend\n"
        gsub_file 'config/routes.rb', "devise_for :users\n", "devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }\n"
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
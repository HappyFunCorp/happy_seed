module HappySeed
  module Generators
    class DeviseInvitableGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_device_invitable
        unless gem_available?( "devise" )
          puts "The devise invitable generator requires devise"

          if yes?( "Run happy_seed:devise now?" )
            generate "happy_seed:devise"
          else
            exit
          end
        end

        gem 'devise_invitable'

        Bundler.with_clean_env do
          run "bundle install --without production"
          run 'rake db:migrate'
        end

        run 'rails generate devise_invitable:install'
        run 'rails generate devise_invitable User'
        run 'rails generate devise_invitable:views'
        
        directory '.'

        if gem_available?( "haml-rails" )
          remove_file 'app/views/devise/invitations/new.html.erb'
          remove_file 'app/views/devise/invitations/edit.html.erb'
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
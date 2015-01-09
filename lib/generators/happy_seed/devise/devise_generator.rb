module HappySeed
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        if !gem_available?( "bootstrap-sass" )
          if yes?( "Bootstrap-sass gem doesn't seem to be installed, install now?" )
            generate "happy_seed:bootstrap"
          end
        end

        gem 'devise', '~> 3.4'

        Bundler.with_clean_env do
          run "bundle install > /dev/null"
        end

        run 'rails generate devise:install'
        run 'rails generate devise User'
        run 'rails generate devise:views'
        
        if gem_available?( "haml-rails" )
          remove_file 'app/views/devise/registrations/new.html.erb'
          remove_file 'app/views/devise/sessions/new.html.erb'
          remove_file 'app/views/devise/passwords/edit.html.erb'
          remove_file 'app/views/devise/passwords/new.html.erb'
        end

        remove_file "spec/factories/users.rb"
        
        begin
          prepend_to_file 'spec/spec_helper.rb', "require 'devise'\n"
          inject_into_file 'spec/spec_helper.rb', "\n  config.include Devise::TestHelpers, type: :controller\n", :before => "\nend\n"
        rescue
          say_status :spec, "Unable to add devise helpers to spec_helper.rb", :red
        end

        directory 'app'
        directory 'docs'
        directory 'test'
        directory 'spec'

        application(nil, env: "development") do
          "config.action_mailer.default_url_options = { host: 'localhost:3000' }"
        end

        application(nil, env: "test") do
          "config.action_mailer.default_url_options = { host: 'localhost:3000' }"
        end

        if File.exists?( File.join( destination_root, 'app/views/application/_header.html.haml' ) )
          gsub_file 'app/views/application/_header.html.haml', "/ USER NAV", <<-'RUBY'

        %ul.nav.navbar-nav.navbar-right
          - if user_signed_in?
            %li= link_to 'Sign Out', destroy_user_session_path, :method=>:delete
          - else
            / CONNECT
            %li= link_to 'Sign In', new_user_session_path
            %li= link_to 'Sign Up', new_user_registration_path
  RUBY
        else
          say_status :gsub_file, "Can't find application/_header.html.haml, skipping"
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
module Seed
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        gem 'devise'

        run "bundle install"

        run 'rails generate devise:install'
        run 'bundle install'
        run 'rails generate devise User'
        run 'rails generate devise:views'
        
        remove_file 'app/views/devise/registrations/new.html.erb'
        remove_file 'app/views/devise/sessions/new.html.erb'
        remove_file 'app/views/devise/passwords/edit.html.erb'
        remove_file 'app/views/devise/passwords/new.html.erb'

        directory 'app'

        gsub_file 'app/views/application/_header.html.haml', "/ USER NAV", <<-'RUBY'
%ul.nav.navbar-nav.navbar-right
        - if user_signed_in?
          %li= link_to 'Sign Out', user_session_path, :method=>:destroy
        - else
          / CONNECT
          %li= link_to 'Sign In', new_user_session_path
          %li= link_to 'Sign Up', new_user_registration_path
RUBY
      end
    end
  end
end
module HappySeed
  module Generators
    class AngularInstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_angular
        gem 'angularjs-rails'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        directory "app"
        directory "docs"
        append_to_file 'app/assets/javascripts/application.js', <<-'JS'

//= require angular
//= require angular-animate
//= require angular-resource
//= require angular-route
//= require angular_app
//= require_tree ./controllers
JS
        gsub_file "config/routes.rb", /\s*root.*\n/, "\n"
        route "root 'angular#index'"
        generate 'happy_seed:angular_view landing'
      end
    end
  end
end

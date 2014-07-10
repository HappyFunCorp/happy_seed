module Seed
  module Generators
    class SplashGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_landing_page
        gem 'gibbon'

        run "bundle install"

        remove_file 'public/index.html'

        route "root 'splash#index'"
        route "post '/signup' => 'splash#signup', as: :splash_signup"

        directory 'app'
      end
    end
  end
end
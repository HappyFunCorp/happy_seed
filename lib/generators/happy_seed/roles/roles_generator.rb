require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/devise/devise_generator'

module HappySeed
  module Generators
    class RolesGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'cancancan'
      end

      def install_roles
        return if already_installed

        require_generator DeviseGenerator

        gem 'cancancan'

        Bundler.with_clean_env do
          run "bundle install --without production"
          run 'rake db:migrate'
        end

        template "ability.rb", "app/models/ability.rb"
        directory "docs"

        generate 'migration add_role_to_users role:integer'

        inject_into_class "app/models/user.rb", "User", "  enum role: [:user, :admin]\n"

        inject_into_file 'app/controllers/application_controller.rb', 
          "\n\n  def access_denied(exception)\n    redirect_to root_path, alert: exception.message\n  end\n",
          before: /\nend/
      end
    end
  end
end

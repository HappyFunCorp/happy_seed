require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class AdminGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'activeadmin'
      end

      def install_active_admin
        return if already_installed

        gem 'devise'
        gem 'activeadmin', github: 'activeadmin', branch: 'master'
        gem 'inherited_resources' # , github: 'josevalim/inherited_resources', branch: 'rails-4-2'
        gem 'dateslices'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        generate 'active_admin:install'

        remove_file "app/admin/dashboard.rb"
        remove_file "spec/factories/admin_users.rb"

        directory 'app'
        directory "docs"
        directory "spec"
        directory "vendor"

        insert_into_file "config/initializers/active_admin.rb", "  config.register_javascript '//www.google.com/jsapi'\n  config.register_javascript 'chartkick.js'\n", :after => "To load a javascript file:\n"
        append_to_file "config/initializers/assets.rb", "\nRails.application.config.assets.precompile += %w( chartkick.js )\n"

        inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do <<-'RUBY'
      g.scaffold_controller "scaffold_controller"
RUBY
        end

        route <<-'ROUTE'
namespace :admin do
    # get "/stats" => "stats#stats"
    devise_scope :admin_user do
      get '/stats/:scope' => "stats#stats", as: :admin_stats
    end
  end
ROUTE

      
      end

      protected
        def fingerprint
          gem_available?( 'activeadmin' )
        end
    end
  end
end

require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/roles/roles_generator'
require 'generators/happy_seed/ckeditor/ckeditor_generator'


module HappySeed
  module Generators
    class AdminGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'activeadmin'
      end

      def install_active_admin
        return if already_installed

        seperate_admin_user = yes? "Install seperate AdminUser (otherwise add role to User)?"

        if !seperate_admin_user
          require_generator RolesGenerator
        end

        require_generator CkeditorGenerator

        gem 'activeadmin', github: 'activeadmin'
        gem 'inherited_resources', github: 'activeadmin/inherited_resources'
        gem 'ransack',    github: 'activerecord-hackery/ransack'
        gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
        gem 'formtastic', github: 'justinfrench/formtastic'
        gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'

        # To fix a Draper deprecation error
        gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'

        gem 'dateslices'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        if seperate_admin_user
          generate 'active_admin:install'
        else
          generate 'active_admin:install --skip-users'
        end

        remove_file "app/admin/dashboard.rb"
        remove_file "spec/factories/admin_users.rb"

        directory 'app'
        directory "docs"
        directory "spec"
        directory "vendor"

        insert_into_file "config/initializers/active_admin.rb", "  config.register_javascript '//www.google.com/jsapi'\n  config.register_javascript 'chartkick.js'\n  config.register_javascript 'ckeditor/init.js'", :after => "To load a javascript file:\n"

        if !seperate_admin_user
          gsub_file "config/initializers/active_admin.rb", /# config.authentication_method.*/, "config.authentication_method = :authenticate_user!"
          gsub_file "config/initializers/active_admin.rb", /# config.authorization_adapter = ActiveAdmin::CanCanAdapter/, "config.authorization_adapter = ActiveAdmin::CanCanAdapter"
          gsub_file "config/initializers/active_admin.rb", /# config.on_unauthorized_access = :access_denied/, "config.on_unauthorized_access = :access_denied"
          gsub_file "config/initializers/active_admin.rb", /# config.current_user_method.*/, "config.current_user_method = :current_user"
          gsub_file "config/initializers/active_admin.rb", /config.logout_link_path.*/, "config.logout_link_path = :destroy_user_session_path"
          gsub_file "config/initializers/active_admin.rb", /# config.logout_link_method.*/, "config.logout_link_method = :delete"
        end

        append_to_file "config/initializers/assets.rb", "\nRails.application.config.assets.precompile += %w( chartkick.js )\n"

        inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do <<-'RUBY'
      g.scaffold_controller "scaffold_controller"
RUBY
        end

        inject_into_file "config/environments/production.rb", "  config.assets.precompile += Ckeditor.assets\n  config.assets.precompile += ['ckeditor/*']\n", before: "end\n"
        append_to_file "app/assets/stylesheets/active_admin.scss", "\n.cke_chrome {\n  width: 79.5% !important;\n  overflow: hidden;\n}"

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

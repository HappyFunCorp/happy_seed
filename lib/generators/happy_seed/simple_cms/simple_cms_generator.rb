require 'generators/happy_seed/admin/admin_generator'
require 'generators/happy_seed/splash/splash_generator'

module HappySeed
  module Generators
    class SimpleCmsGenerator < HappySeedGenerator
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        File.exists? 'app/models/simple_content.rb'
      end

      def install_simple_cms
        return if already_installed

        require_generator AdminGenerator
        require_generator SplashGenerator

        migration_template("create_simple_contents.rb", "db/migrate/create_simple_contents.rb" )

        begin
          inject_into_file "app/helpers/application_helper.rb", File.read( find_in_source_paths( "application_helper.rb" ) ), before: /\nend/
        rescue
          say_status :application_helper, "Unable to add helper to app/helpers/application_helper.rb", :red
        end

        route "get '/faq' => 'simple_content#faq'"

        remove_file 'app/views/splash/index.html.haml'
        directory "app"
        directory "docs"
      end

      private
        def self.next_migration_number(dir)
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        end
    end
  end
end
require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class BaseGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        File.exists?( "docs/README.00.base.rdoc" )
      end

      def install_seed_base
        return if already_installed

        puts "Installing happy_seed:base environment"

        # We only want SQLITE in development not everywhere
        gsub_file 'Gemfile', /.*sqlite3.*/, ""

        gem 'puma'
        gem 'rails_12factor'
        gem 'haml-rails'

        gem_group :development, :test do
          gem "sqlite3"
          gem "rspec"
          gem "rspec-rails"
          gem "factory_girl_rails"
          gem "capybara"
          gem "cucumber-rails", :require => false
          gem "guard-rspec"
          gem "guard-cucumber"
          gem "database_cleaner"
          gem "spring-commands-rspec"
          gem 'spring-commands-cucumber'
          gem "quiet_assets"
          gem "launchy"
          gem "vcr"
          gem "faker"
          gem 'dotenv-rails'
          gem 'rdiscount'
        end

        gem_group :test do
          gem "webmock"
        end

        gem_group :production do
          gem 'pg'
        end

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        gsub_file "app/assets/javascripts/application.js", /= require turbolinks/, "require turbolinks"

        # Install rspec
        generate "rspec:install"
        gsub_file ".rspec", "--warnings\n", ""
        append_to_file ".rspec", "--format documentation\n"

        # Install cucumber
        generate "cucumber:install"

        append_to_file "features/support/env.rb", "\nWorld(FactoryGirl::Syntax::Methods)\n"

        # Install Guard
        run "guard init"

        # Use the spring version and also run everything on startup
        gsub_file "Guardfile", 'cmd: "bundle exec rspec"', 'cmd: "bin/rspec", all_on_start: true'
        gsub_file "Guardfile", 'guard "cucumber"', 'guard "cucumber", cli: "--color --strict"'

        directory '.'
        append_to_file '.gitignore', ".env\n"

        remove_file "application_controller.rb"

        inject_into_file 'app/controllers/application_controller.rb', File.read( find_in_source_paths('application_controller.rb') ), :after=>/protect_from_forgery.*\n/
        inject_into_class 'config/application.rb', :Application, "    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')"
        inject_into_file 'config/environments/test.rb', "  config.log_level = :error\n", before: "end\n"

        begin
          inject_into_file 'spec/rails_helper.rb', "require 'webmock/rspec'\n", after: "'rspec/rails'\n"
        rescue
          say_status :spec, "Unable to add webmock to rails_helper.rb", :red
        end

        begin
          inject_into_file 'spec/rails_helper.rb', "\n  config.include FactoryGirl::Syntax::Methods\n", :before => "\nend\n"
          append_to_file 'spec/rails_helper.rb', "\nVCR.configure do |c|\n  c.cassette_library_dir  = Rails.root.join('spec', 'vcr')\n  c.hook_into :webmock\nend\n"
        rescue
          say_status :spec, "Unable to add factory girl and VCR to rails_helper.rb", :red
        end

        route "get '/setup' => 'setup#index'"
        route "root 'setup#index'"
      end
    end
  end
end

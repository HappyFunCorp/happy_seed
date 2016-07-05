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
          gem 'sqlite3'
          gem 'rspec', '~> 3.5.0'
          gem 'rspec-rails', '~> 3.5.0'
          gem 'factory_girl_rails'
          gem 'capybara'
          gem 'cucumber-rails', branch: 'rails-5', require: false
          gem 'guard-rspec', '~> 4.6.4', require: false
          gem 'guard-cucumber'
          gem 'database_cleaner'
          gem 'spring-commands-rspec'
          gem 'spring-commands-cucumber'
          gem 'launchy'
          gem 'vcr'
          gem 'faker'
          gem 'dotenv-rails'
          gem 'rdiscount'
          gem 'rails-controller-testing'
          gem 'better_errors'
          gem 'binding_of_caller'
        end

        gem_group :test do
          gem 'webmock'
          gem 'fakeredis', require: 'fakeredis/rspec'
        end

        gem_group :production do
          gem 'pg'
          gem 'lograge'
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
        # gsub_file "Guardfile", 'guard "cucumber"', 'guard "cucumber", cli: "--color --strict"'

        directory '.'
        append_to_file '.gitignore', ".env\n"

        remove_file "application_controller.rb"
        remove_file "test"

        inject_into_file 'app/controllers/application_controller.rb', 
          File.read( find_in_source_paths('application_controller.rb') ), 
          after: /protect_from_forgery.*\n/

        inject_into_class 'config/application.rb', 
          :Application, 
          "    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')"

        inject_into_file 'config/environments/test.rb', 
          "  config.log_level = :error\n", 
          before: "end\n"

        inject_into_file 'config/environments/development.rb', 
          "  config.assets.quiet = true\n", 
          before: "end\n"

        inject_into_file 'config/environments/production.rb', 
          "  config.lograge.enabled = true\n  config.assets.quiet = true\n", 
          before: "end\n"

        begin
          inject_into_file 'spec/rails_helper.rb', "require 'webmock/rspec'\n", after: "'rspec/rails'\n"
        rescue
          say_status :spec, "Unable to add webmock to rails_helper.rb", :red
        end

        begin
          inject_into_file 'spec/rails_helper.rb', "\n  config.include FactoryGirl::Syntax::Methods\n", :before => "\nend\n"
          inject_into_file 'spec/rails_helper.rb', "\n  [:controller, :view, :request].each do |type|\n    config.include ::Rails::Controller::Testing::TestProcess, :type => type\n    config.include ::Rails::Controller::Testing::TemplateAssertions, :type => type\n    config.include ::Rails::Controller::Testing::Integration, :type => type\n  end", :before => "\nend\n"
          append_to_file 'spec/rails_helper.rb', "\nVCR.configure do |c|\n  c.cassette_library_dir  = Rails.root.join('spec', 'vcr')\n  c.hook_into :webmock\nend\n"
        rescue
          say_status :spec, "Unable to add factory girl and VCR to rails_helper.rb", :red
        end

        begin
          inject_into_file 'Rakefile', "module TempFixForRakeLastComment\n  def last_comment\n    last_description\n  end\nend\nRake::Application.send :include, TempFixForRakeLastComment\n", before: "Rails.application.load_tasks"
        rescue 
          say_status :spec, "Unable to add Rake workaround for last_comment"
        end

        route "get '/setup' => 'setup#index'"
        route "root 'setup#index'"
      end
    end
  end
end

require 'generators/happy_seed/happy_seed_generator'

module HappySeed
  module Generators
    class BootstrapGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'bootstrap-sass'
      end

      def install_bootstrap
        return if already_installed

        gem 'bootstrap-sass'
        gem 'modernizr-rails'
        gem 'meta-tags', :require => 'meta_tags'
        gem 'responders', '~> 2.0'
        gem 'bh'
        gem 'simple_form'

        Bundler.with_clean_env do
          run "bundle install --without production"
          run "rails generate simple_form:install --bootstrap"
        end

        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/assets/javascripts/application.js'
        remove_file 'app/helpers/application_helper.rb'
        remove_file 'app/assets/stylesheets/application.css'
        directory 'app'
        directory 'lib'
        directory 'docs'

        inject_into_file 'app/views/setup/index.html.haml', after: "%body\n" do <<-'HAML'
    = render partial: "application/header"
    = render partial: "application/flashes"
HAML
        end

        inject_into_file 'config/application.rb', before: "  end\nend\n" do <<-'RUBY'
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.generators do |g|
      g.stylesheets = false
      g.scaffold_controller "scaffold_controller"
      g.test_framework :rspec, fixture: true, fixture_replacement: :factory_girl, helper_specs: false, view_specs: false, routing_specs: false, controller_specs: false
    end
  
RUBY
        end
        if File.exists?( File.join( destination_root, ".env" ) )
          add_env "GOOGLE_ANALYTICS_SITE_ID"
        end
      end
    end
  end
end

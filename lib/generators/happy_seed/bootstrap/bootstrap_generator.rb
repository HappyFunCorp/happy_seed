module HappySeed
  module Generators
    class BootstrapGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def update_application_haml
        gem 'bootstrap-sass'
        gem 'modernizr-rails'

        Bundler.with_clean_env do
          run "bundle install"
        end

        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/assets/javascripts/application.js'
        remove_file 'app/helpers/application_helper.rb'
        directory 'app'
        directory 'lib'
        directory 'docs'

        inject_into_file 'config/application.rb', before: "end\nend\n" do <<-'RUBY'
  config.generators do |g|
      g.stylesheets = false
    end
RUBY
        end
        append_to_file ".env", "GOOGLE_ANALYTICS_SITE_ID=\n"
      end
    end
  end
end
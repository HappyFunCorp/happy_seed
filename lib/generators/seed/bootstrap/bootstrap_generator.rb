module Seed
  module Generators
    class BootstrapGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def update_application_haml
        gem 'bootstrap-sass'
        gem 'modernizr-rails'

        run "bundle install"

        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/assets/javascripts/application.js'
        remove_file 'app/helpers/application_helper.rb'
        directory 'app'
        directory 'lib'

        inject_into_file 'config/application.rb', before: "end\nend\n" do <<-'RUBY'
  config.generators do |g|
      g.stylesheets = false
    end
RUBY
        end
      end
    end
  end
end
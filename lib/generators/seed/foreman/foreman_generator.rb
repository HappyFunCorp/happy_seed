module Seed
  module Generators
    class ForemanGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_foreman
        gem 'dotenv-rails', :groups=>[:development, :test]
        gem 'unicorn'
        gem 'dotenv-rails', :groups=>[:development, :test]
        gem 'rails_12factor'

        run 'bundle install'

        directory '.'
      end
    end
  end
end
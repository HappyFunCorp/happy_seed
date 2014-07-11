module Seed
  module Generators
    class ForemanGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_foreman
        gem 'dotenv-rails', :groups=>[:development, :test]
        gem 'unicorn'
        gem 'rails_12factor'

        Bundler.with_clean_env do
          run "bundle install"
        end

        directory '.'
      end
    end
  end
end
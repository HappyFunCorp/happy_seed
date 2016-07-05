require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/bootstrap/bootstrap_generator'

module HappySeed
  module Generators
    class CkeditorGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'ckeditor'
      end

      def install_html_email
        return if already_installed

        require_generator BootstrapGenerator

        gem 'ckeditor'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        inject_into_file "config/environments/production.rb", "  config.assets.precompile += Ckeditor.assets\n  config.assets.precompile += ['ckeditor/*']\n", before: "end\n"
        inject_into_file "app/assets/javascripts/application.js", "\n//= require ckeditor/init", after: "//= require bootstrap-sprockets"

        directory "."
      end
    end
  end
end
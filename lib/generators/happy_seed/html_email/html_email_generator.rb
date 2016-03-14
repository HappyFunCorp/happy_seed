require 'generators/happy_seed/happy_seed_generator'
require 'generators/happy_seed/bootstrap/bootstrap_generator'

module HappySeed
  module Generators
    class HtmlEmailGenerator < HappySeedGenerator
      source_root File.expand_path('../templates', __FILE__)

      def self.fingerprint
        gem_available? 'premailer-rails'
      end

      def install_html_email
        return if already_installed

        gem 'premailer-rails'
        gem 'nokogiri'

        Bundler.with_clean_env do
          run "bundle install --without production"
        end

        run 'bin/spring stop'

        remove_file 'app/views/layouts/mailer.html.erb'

        directory "."

      end
    end
  end
end
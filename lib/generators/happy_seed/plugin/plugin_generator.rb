require 'thor'

module HappySeed
  module Generators
    class PluginGenerator < Thor::Group
      include Thor::Actions
      source_root File.expand_path('../templates', __FILE__)
      def generate_rails_plugin
        source_root = File.expand_path('../templates', __FILE__)
        app_name = ARGV.shift
        system "rails plugin new #{app_name} -T --dummy-path=spec/dummy #{ARGV.join( " ")}"

        insert_into_file "#{app_name}/#{app_name}.gemspec", File.read( "#{source_root}/gemspec" ), :before => "\nend\n"

        system( "cd #{app_name} && bundle" )

        system( "cd #{app_name}/spec/dummy && rails g rspec:install")

        gsub_file "#{app_name}/spec/dummy/.rspec", "--warnings\n", ""
        append_to_file "#{app_name}/spec/dummy/.rspec", "--format documentation\n"

        destination_root = app_name

        copy_file "Rakefile"
        directory "spec"
      end
    end
  end
end

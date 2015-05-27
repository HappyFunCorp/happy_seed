require 'thor'

module HappySeed
  module Generators
    class StaticGenerator < Thor::Group
      include Thor::Actions
      source_root File.expand_path('../templates', __FILE__)
      def generate_rails_plugin
        # source_root = File.expand_path('../templates', __FILE__)
        args.shift
        app_name = args.shift

        self.destination_root = app_name

        directory "."
      end
    end
  end
end

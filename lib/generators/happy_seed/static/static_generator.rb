require 'thor'

module HappySeed
  module Generators
    class StaticGenerator < Thor::Group
      include Thor::Actions
      source_root File.expand_path('../templates', __FILE__)
      def generate_rails_plugin
        source_root = File.expand_path('../templates', __FILE__)
        args.shift
        app_name = args.shift

        puts "App name: #{app_name}"
        self.destination_root = app_name

        directory "."
      end
    end
  end
end

#         system "rails plugin new #{app_name} -T --dummy-path=spec/dummy #{args.join( " ")}"

#         insert_into_file "#{app_name}/#{app_name}.gemspec", File.read( "#{source_root}/gemspec" ), :before => "\nend\n"

#         system( "cd #{app_name} && bundle" )

#         system( "cd #{app_name}/spec/dummy && rails g rspec:install")

#         gsub_file "#{app_name}/spec/dummy/.rspec", "--warnings\n", ""
#         append_to_file "#{app_name}/spec/dummy/.rspec", "--format documentation\n"

#         self.destination_root = app_name
        
#         remove_file "Rakefile"
#         copy_file "Rakefile"
#         copy_file ".rspec"
#         copy_file ".autotest"
#         directory "spec"
#       end
#     end
#   end
# end

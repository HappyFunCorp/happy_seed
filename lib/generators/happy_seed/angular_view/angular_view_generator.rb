module HappySeed
  module Generators
    class AngularViewGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def install_view_page
        template "app/assets/javascripts/controllers/controller.js.coffee", "app/assets/javascripts/controllers/#{file_name}.js.coffee"
        template "app/assets/templates/view.html", "app/assets/templates/#{file_name}.html"
        insert_into_file "app/assets/javascripts/angular_app.js.coffee.erb", "    when('/#{file_name}',            {templateUrl: '<%= asset_path('#{file_name}.html' )%>',  controller: '#{class_name}Ctrl'}).
\n", :before => /\s*otherwise/
        directory "docs"
      end
    end
  end
end

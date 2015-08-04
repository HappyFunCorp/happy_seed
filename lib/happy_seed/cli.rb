require 'thor'
require 'happy_seed/wizard'

module HappySeed
  class Cli < Thor
    desc "rails APPNAME", "Generate a new rails application"
    def rails( *args )
      seedrb = gem_file_path( "happy_seed.rb")
      system "rails new -m #{seedrb} #{args.join( " " )} --skip-turbolinks"
    end

    desc "plugin NAME", "Generate a new rails plugin"
    def plugin( *args )
      require 'generators/happy_seed/plugin/plugin_generator'
      HappySeed::Generators::PluginGenerator.start
    end

    desc "engine NAME", "Generate a new rails engine"
    def engine( *args )
      require 'generators/happy_seed/plugin/plugin_generator'
      ARGV << "--mountable"
      HappySeed::Generators::PluginGenerator.start
    end

    desc "static NAME", "Generate a new middleman static project"
    def static( name )
      require 'generators/happy_seed/static/static_generator'
      HappySeed::Generators::StaticGenerator.start
    end

    desc "static_blog NAME", "Generate a new middleman static blog project"
    def static_blog( name )
      require 'generators/happy_seed/static_blog/static_blog_generator'
      HappySeed::Generators::StaticBlogGenerator.start
    end

    private
    def gem_file_path( filename )
      spec = Gem::Specification.find_by_name("happy_seed")
      gem_root = spec.gem_dir

      File.join( gem_root, filename )
    end
  end
end
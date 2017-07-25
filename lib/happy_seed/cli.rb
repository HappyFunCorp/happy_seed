require 'happy_seed/version'
require 'thor'

module HappySeed
  class Cli < Thor
    desc "version", "Prints out the current version"
    def version
      puts "You are running seed version #{HappySeed::VERSION}"
    end

    desc "rails APPNAME", "Generate a new rails application"
    def rails( *args )
      seedrb = gem_file_path( "happy_seed.rb")
      system "rails new -m #{seedrb} #{args.join( " " )} --skip-turbolinks --skip-test-unit"
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
    
    desc "reference", "Quick generator Reference"    
    def reference    
      puts File.read( File.expand_path( "../../happy_seed.txt", File.dirname( __FILE__ ) ) )   
    end

    private
    def gem_file_path( filename )
      spec = Gem::Specification.find_by_name("happy_seed")
      gem_root = spec.gem_dir

      File.join( gem_root, filename )
    end
  end
end

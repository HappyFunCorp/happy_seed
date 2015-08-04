begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HappySeed'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end




Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task default: :test

desc "Copy readme files into the doc directory"
task :sync_docs do
  system( "mkdir -p website/source/docs" )
  `find lib -name README\\* -print`.each_line do |file|
    file.gsub!( /\n/, "" )
    out = file.gsub( /.*\//, "" ).gsub( /.rdoc/, ".html.markdown" )
    # puts file, out
    system( "cp #{file} website/source/docs/#{out}" )
  end
end

desc "Generate dependancy graph"
task :generator_dependancies do
  require 'active_support/inflector'

  Dir.glob( 'lib/generators/**/*_generator.rb' ).each do |f|
    data = File.read f
    # name = data.lines.select { |x| x =~ /class/ }.first.gsub( /.*class (.*?)Generator.*/m, '\1' ).underscore
    name = data.grep( /class/ ).first.gsub( /.*class (.*?)Generator.*/m, '\1' ).underscore

    if name != 'happy_seed'
      print = false

      if data.grep( /require_omniauth/ ).size > 0
        puts "[#{name}] -> [omniauth]"
        print = true
      end

      data.grep( /generate .happy_seed/ ).each do |line|
        dep = line.gsub( /.*happy_seed:([^"' ]*).*/m, '\1' )
        puts "[#{name}] -> [#{dep}]"
        print = true
      end

      if name == 'base'
        puts "[base]"
        print = true
      end

      if ['plugin', 'static', 'static_blog'].index( name )
        # puts "Skipping #{name}"
        print = true
      end

      puts "[#{name}] -> [base]" unless print

    end
  end
end

class String
  def grep( regex )
    lines.select { |x| x =~ regex }
  end
end
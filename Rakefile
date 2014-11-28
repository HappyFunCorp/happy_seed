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

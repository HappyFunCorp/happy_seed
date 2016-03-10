$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "happy_seed/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "happy_seed"
  s.version     = HappySeed::VERSION
  s.authors     = ["Will Schenk", "Ricky Reusser"]
  s.email       = ["will@happyfuncorp.com"]
  s.homepage    = "http://seed.happyfuncorp.com"
  s.summary     = "HappySeed is a project that will build up a rails apps using some common best practices."
  s.description = "HappySeed is a project that will build up a rails apps using some common best practices."
  s.license     = "MIT"

  s.files = Dir["{app,bin,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc", "happy_seed.rb", "happy_seed.txt", "lib/**/.*"]
  s.test_files = Dir["test/**/*"]
  s.executables << "happy_seed"
  s.add_dependency "rails", "~> 5.0.0.beta1"
  s.add_dependency "thor"

  s.add_development_dependency "sqlite3"
end

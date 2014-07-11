$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seed/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seed"
  s.version     = Seed::VERSION
  s.authors     = ["Will Schenk", "Ricky Reusser"]
  s.email       = ["will@happyfuncorp.com"]
  s.homepage    = "https://github.com/sublimeguile/seed"
  s.summary     = "Seed is a project that will build up a rails apps using some common best practices."
  s.description = "Seed is a project that will build up a rails apps using some common best practices."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"
end

gsub_file 'Gemfile', /.*sqlite3.*/, ""
gem 'haml-rails'
gem "httparty"

gem_group :development, :test do
  gem "sqlite3"
  gem "rspec"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "capybara"
  gem "cucumber-rails", :require => false
  gem "guard-rspec"
  gem "guard-cucumber"
  gem "database_cleaner"
end

gem_group :test do
  gem "webmock"
end

gem_group :production do
  gem 'pg'
end

if ENV['SEED_DEVELOPMENT']
  gem 'happy_seed', :path => File.dirname(__FILE__)
else
  gem 'happy_seed'
end

puts `pwd`
puts "Running bundle install"

Bundler.with_clean_env do
  run "bundle install"

  if !File.exists? "/Users/wschenk/src/happy_seed/ta/Gemfile.lock"
    puts "Gemfile.lock should exist"
    exit
  end

  gsub_file "app/assets/javascripts/application.js", /= require turbolinks/, "require turbolinks"

  # Install rspec
  generate "rspec:install"
  gsub_file ".rspec", "--warnings\n", ""
  append_to_file ".rspec", "--format documentation\n"

  # Install cucumber
  generate "cucumber:install"


  # Run the base generator
  generate "happy_seed:base"

  all_in = false
  all_in = true if yes? "Would you like to install everything?"

  packages = []

  if all_in || yes?( "Would you like to install bootstrap?" )
    generate "happy_seed:bootstrap"
    packages << "bootstrap"

    if all_in || yes?( "Would you like to install splash page?" )
      generate "happy_seed:splash"
      packages << "splash"
    end
  end

  if all_in || yes?( "Would you like to install devise?" )
    generate "happy_seed:devise"
    packages << "devise"

    if all_in || yes?( "Would you like to install twitter?" )
      generate "happy_seed:twitter"
      packages << "twitter"
    end

    if all_in || yes?( "Would you like to install facebook connect?" )
      generate "happy_seed:facebook"
      packages << "facebook"
    end

    if all_in || yes?( "Would you like to install instagram?" )
      generate "happy_seed:instagram"
      packages << "instagram"
    end
  end

  if all_in || yes?( "Would you like to install active admin?" )
    generate "happy_seed:admin"
    packages << "admin"
  end

  if yes?( "You would like to install angular?" )
    generate "happy_seed:angular_install"
    packages << "angular"
  end

  if yes?( "You would like to install jazz hands?" )
    generate "happy_seed:jazz_hands"
    packages << "jazz_hands"
  end

  puts "Adding rake task to convert templates to ERB. If you need to do this, please run:"
  puts "rake html2erb"
  rakefile "haml2erb.rake",
  %q{
  desc "Converts everything to erb"
  task :haml2erb do
    require 'httparty'

    FileUtils.mkdir_p "lib/templates/erb"

    Dir.glob( "**/*.haml").each do |f|
      puts "Converting #{f}"

      data = File.read( f )

      resp = HTTParty.post( "http://haml2erb.herokuapp.com/api.html", { query: { haml: data } } )

      puts "FROM--------"
      puts data
      puts "TO--------"
      puts resp.body

      outfile = f.gsub( /\.haml/, ".erb" )

      if outfile =~ /templates\/haml/
        outfile.gsub!( /templates\/haml/, "templates/erb" )
        puts "outfile = #{outfile}"

        FileUtils.mkdir_p( Pathname.new( outfile ).dirname )
      end

      File.open( outfile, "w" ) do |out|
        out.puts resp.body
      end

      FileUtils.mv( f, "#{f}.bak" )
    end
  end
  }
  puts "Setting up git"
  git :init
  git add: "."
  git commit: "-a -m 'Based off of happy_seed: #{packages.join( ', ')} included'"
end
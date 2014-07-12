gem 'haml-rails'
gem 'meta-tags', :require => 'meta_tags'
if ENV['SEED_DEVELOPMENT']
  gem 'happy_seed', :path => File.dirname(__FILE__)
else
  gem 'happy_seed'
end
gsub_file "Gemfile", /^#\s*Turbolinks.*$/,'# No one likes Turbolinks.'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,'# gem \'turbolinks\''
#gsub_file "Gemfile", /^gem\s+["']spring["'].*$/,'# gem \'spring\''

run 'bundle install'

gsub_file "app/assets/javascripts/application.js", /= require turbolinks/, "require turbolinks"

# Run the base generator
generate "happy_seed:foreman"

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
end

if all_in || yes?( "Would you like to install active admin?" )
  generate "happy_seed:admin"
  packages << "admin"
end

puts "Setting up git"
git :init
git add: "."
git commit: "-a -m 'Based off of happy_seed: #{packages.join( ', ')} included'"


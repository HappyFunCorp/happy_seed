gem 'haml-rails'
gem 'meta-tags', :require => 'meta_tags'
gem 'devise'
gem 'seed', :path => "/Users/wschenk/src/seed"
gsub_file "Gemfile", /^#\s*Turbolinks.*$/,'# No one likes Turbolinks.'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,'# gem \'turbolinks\''

# Run the base generator
generate "seed:foreman"

if yes? "Would you like to install bootstrap?"
  generate "seed:bootstrap"

  if yes? "Would you like to install splash page?"
    generate "seed:splash"
  end
end

if yes? "Would you like to install devise?"
  generate "seed:devise"

  if yes? "Would you like to install twitter?"
    generate "seed:twitter"
  end

  if yes? "Would you like to install facebook connect?"
    generate "seed:facebook"
  end
end

if yes? "Would you like to install active admin?"
  generate "seed:admin"
end

puts "Setting up git"
git :init


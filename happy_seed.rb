require 'bundler'

puts "Setting up basic template"
puts

gem_group :development do
  if ENV['SEED_DEVELOPMENT']
    gem 'happy_seed', :path => ENV['SEED_DEVELOPMENT'] # File.dirname(__FILE__)
  else
    gem 'happy_seed'
  end
end

@packages = [ 'base' ]

def run_graph graph
  graph.each do |node|
    if yes?( "Install #{node[:name]}, #{node[:desc]}?" )
      generate "happy_seed:#{node[:name]}"
      @packages << node[:name]

      run_graph node[:subtree] if node[:subtree]
    end
  end
end

Bundler.with_clean_env do
  run "bundle install --without production"

  # Run the base generator
  generate "happy_seed:base"

  puts "Base generator installed."

  puts File.read( File.expand_path( "happy_seed.txt", File.dirname( __FILE__ ) ) )

  GRAPH = [
    {name: 'splash', desc: 'Basic splash page' },
    {name: 'simple_cms', desc: 'Simple CMS' },
    {name: 'devise', desc: 'User profiles', subtree: [
      {name: 'roles', desc: 'User roles'},
      {name: 'devise_invitable', desc: 'Invitable users'},
      {name: 'devise_confirmable', desc: 'Confirmable users'},
      {name: 'facebook', desc: 'OAuth: Connect with facebook' },
      {name: 'github', desc: 'OAuth: Connect with github' },
      {name: 'googleoauth', desc: 'OAuth: Connect wuth google' },
      {name: 'instagram', desc: 'OAuth: Instagram' },
      {name: 'twitter', desc: 'OAuth: twitter' },
      ]},
    {name: 'admin', desc: 'Active Admin for back office adminstration' },
    {name: 'api', desc: 'Provide API for mobile device (Beta)' },
    {name: 'react', desc: 'Setup react-on-rails' },
    {name: 'angular_install', desc: 'Setup an angular application' },
    {name: 'jazz_hands', desc: 'Better Rails Console tools' }
  ]

  run_graph GRAPH

  run "bundle exec spring binstub --all"

  puts "Setting up git"
  git :init
  git add: "."
  git commit: "-a -m 'Based off of happy_seed: #{@packages.join( ', ')} included'"
end


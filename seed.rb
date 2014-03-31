APP_NAME = ARGV[0].humanize

# Always enabled for now. But I'll at least leave it configurable
USE_BOOTSTRAP = true

# Ruby setup
file '.ruby-version', <<-CODE
#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}
CODE


# Just in case:
remove_file 'public/index.html'


# Environment setup
file '.env', <<-CODE
MAILER_HOST=localhost:3000
CODE


# Gem setup

# Is it proper to go ahead and install non-proeject gems?
#
# Well, we'll at least check and see if it's already accessible.
#
run 'gem install foreman' unless require 'foreman'

# Is this really necessary?
run 'gem install compass' unless require 'compass'



# Because no one likes Turbolinks.
gsub_file "Gemfile", /^#\s*Turbolinks.*$/,'# No one likes Turbolinks.'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,'# gem \'turbolinks\''
gsub_file "app/assets/javascripts/application.js", /\/\/=\s+require\s+turbolinks.*$/, '// require turbolinks'



# Nice to have:
gem 'haml-rails'
gem 'unicorn'
gem 'dotenv'
gem 'rails_12factor'
gem 'meta-tags', :require => 'meta_tags'



# Feels like there's some redundancy here:
gem 'bootstrap-sass'
gem 'compass-rails'
gem 'compass-h5bp', :group=>:assets
gem 'html5-rails'





# Generate html5 boilerplate:
run 'rails generate html5:install'


# Clean up stupid stuff the html5 boilerplate generator has done:

# The last thing we want is important includes buried in the gem somewhere:
run 'rails generate html5:partial --all'

# Not a chance we're letting any config into yaml files:
remove_file 'config/html5_rails.yml'

# Don't even leave the door open for yaml config:
gsub_file 'app/views/application/_javascripts.html.haml', /-# Looks for google_account_id.*\n/, ''
gsub_file 'app/views/application/_javascripts.html.haml', /google_account_id/, "ENV['GOOGLE_ACCOUNT_ID']"
append_file '.env', 'GOOGLE_ACCOUNT_ID='


# You've overstepped your bounds, html5 boilerplate. Please don't set our page titles:
gsub_file "app/views/application/_head.html.haml", /^.*%title.*$/, ''
gsub_file "app/views/application/_head.html.haml", /^.*==\s*#\{\s*controller\.controller_name.*\}.*\n/, ''

inject_into_file 'app/views/application/_head.html.haml', <<-CODE, :before=>/^.*%meta.*description.*\n/
  = display_meta_tags :site => '#{APP_NAME}'

CODE


append_file 'app/assets/stylesheets/application/index.css.scss', <<-CODE

//-----------------------------------------
// Bootstrap import
//-----------------------------------------
@import 'bootstrap';

//-----------------------------------------
// Add your styles below this line!
//-----------------------------------------
CODE




# SERVER SETUP

file './Procfile', <<-CODE
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
CODE

file '.foreman', <<-CODE
port: 3000
CODE


# Configure unicorn

file './config/unicorn.rb', <<-CODE
worker_processes 3
timeout 30
preload_app true
 
before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
 
  sleep 1
end
 
after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
 
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end
CODE


# Basic environment config
environment "config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }", env: 'development'
environment "config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }", env: 'production'



file "app/controllers/splash_controller.rb", <<-CODE
class SplashController < ApplicationController

  def index
  end

  def signup
  end

end
CODE


file "app/views/splash/index.html.haml", <<-CODE
%main.splash-masthead
  .container
    .row.text-center
      .col-lg-12
        %h1= "\#{Rails.application.class.parent_name} Splash Page"
          
    .row
      .col-lg-6.col-lg-offset-3
        = form_tag splash_signup_path, role: :form, :class=>'form-horizontal', :remote=>true do
          .form-group
            = text_field_tag :test, '',  :class=>'form-control', :placeholder=>'Email address'
          .form-group.text-center
            = submit_tag 'Submit', :class=>'btn btn-primary'

.container
  .row
    .col-lg-12
      %h1 Here's what this template installed:

      %h3 Bootstrap
      %p You should really be using a framework.

      %h3 This splash page
      %code= '/app/views/splash/index.html.haml'

      %h3 Some Gems
      
      

CODE


file "app/views/splash/signup.js.erb", <<-CODE
alert('signed up!');
CODE

route "post '/signup' => 'splash#signup', as: :splash_signup"
route "root to: 'splash#index'"




# GIT SETUP
git :init
git add: "."
git commit: "-a -m 'Initial commit'"


puts "[0;34m***********************************************************************"
puts "\n"
puts "                      Thanks for planting a seed!"
puts "\nAn app with a splash page and some great tools has just been created!"
puts "The next step is to start the server and watch your seed grow!"
puts "\n\t$ cd #{ARGV[0]}"
puts "\t$ foreman start"
puts "\n[0;32m"
puts <<-ASCII_ART
                                        _____
                         _____        _/    /
                         \\    \\_  Y  /    _/
                          \\_    \\ ||<____/
                            \\____>//  
                                 //
                                ||
                                ||
                                ||
________________________________|L_____________________________________
                               _||_
                           ___/ |  \\__
                           _/  / |  \\ \\__
                              |  /   \\  /
ASCII_ART
puts "[0;34m\n\n***********************************************************************[0m"

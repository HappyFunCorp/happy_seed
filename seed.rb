# Ruby setup
file '.ruby-version', <<-CODE
#{RUBY_VERSION}
CODE

# This would work too, but why include the patch level unless necesary, right?
# #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}


# Gem setup
gem 'haml'
gem 'unicorn'
gem 'dotenv'
gem 'rails_12factor'
gem 'bootstrap-sass'
gem 'compass-rails'

run 'gem install foreman'
run 'gem install compass'

# Because no one likes Turbolinks.
gsub_file "Gemfile", /^#\s*Turbolinks.*$/,'# No one likes Turbolinks.'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,'# gem \'turbolinks\''
gsub_file "app/assets/javascripts/application.js", /\/\/=\s+require\s+turbolinks.*$/, '// require turbolinks'


# SERVER SETUP

file './Procfile', <<-CODE
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
CODE

file '.foreman', <<-CODE
port: 3000
CODE

file '.env', <<-CODE
MAILER_HOST=localhost:3000
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




# Splash page setup

BOOTSTRAP_VARIABLES_PATH= "#{`bundle show bootstrap-sass`.gsub(/\n/,'')}/vendor/assets/stylesheets/bootstrap/_variables.scss"

run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'


file 'app/assets/stylesheets/_variables.css.scss', <<-CODE

/*
 * Bootstrap customization variables. You can find a full list of variables here:
 *
 *  http://getbootstrap.com/customize/#less-variables
 *
 * Or here (For reference only! Don't modify this in the gem! Specify changes below.):
 *
 * #{BOOTSTRAP_VARIABLES_PATH}
 *
 * For example:
 *
 * $navbar-default-bg: #312312;
 * $light-orange: #ff8c00;
 * $navbar-default-color: $light-orange;
 */



CODE




file 'app/assets/stylesheets/styles.css.scss', <<-CODE

/*
 * Import something from Compass. It's really useful. You should check it out.
 */
@import "compass/css3/images";

/*
 * Bootstrap customization variables. You can find a full list of variables here:
 *
 *  http://getbootstrap.com/customize/#less-variables
 *
 * Or here (For reference only! Don't modify this in the gem! Specify changes in _variables.css.scss):
 *
 * #{BOOTSTRAP_VARIABLES_PATH}
 *
 */
@import '_variables.css';

/*
 * This is where bootstrap gets included for the project. Don't include it in application.css
 * because then you won't be able to customize it.
 */
@import 'bootstrap.css';


$masthead-top: #138;
$masthead-bot: #188;

.splash-masthead {

  color: #fff;

  padding-top: 120px;
  padding-bottom: 120px;

  background-color: 0.5*($masthead-top + $masthead-bot);
  @include filter-gradient($masthead-top, $masthead-bot, vertical);
  @include background-image(linear-gradient(top, $masthead-top 0%, $masthead-bot 100%));


  form {
    margin-top: 80px;
  }
}
CODE





run 'rm app/views/layouts/application.html.erb'

file 'app/views/layouts/application.html.haml', <<-CODE
!!!
%html
  %head
    %title Testapp
    = stylesheet_link_tag    "application", media: "all"
    = javascript_include_tag "application"
    = csrf_meta_tags
  %body
    = yield
CODE


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
            = text_field_tag :test, '',  :class=>'form-control'
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

# Keep it simple
run 'echo ".env" >> .gitignore'


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


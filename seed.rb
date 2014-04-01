#---------------------------------------------------------------------
# CONFIG
#---------------------------------------------------------------------
APP_NAME = ARGV[0].humanize

# Always enabled for now. But I'll at least leave it configurable
USE_BOOTSTRAP = true

# Ruby setup
file '.ruby-version', <<-CODE
#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}
CODE


#---------------------------------------------------------------------
# .ENV SETUP
#---------------------------------------------------------------------
file '.env', <<-CODE
MAILER_HOST=localhost:3000
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
S3_BUCKET_NAME=
GOOGLE_ACCOUNT_ID=
CODE


#---------------------------------------------------------------------
# GEM SETUP
#---------------------------------------------------------------------

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
gem 'bootstrap-sass' if USE_BOOTSTRAP
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
gsub_file "app/views/application/_head.html.haml", /^.*%title.*\n/s, ''
gsub_file "app/views/application/_head.html.haml", /^.*==\s*#\{\s*controller\.controller_name.*\}.*\n/s, ''

inject_into_file 'app/views/application/_head.html.haml', <<-CODE, :before=>/^.*%meta.*description.*\n/s
  = display_meta_tags :site => '#{APP_NAME}'

CODE



# Enable compass:
gsub_file 'app/assets/stylesheets/application/index.css.scss', /\/\/\s*@import 'compass/, "@import 'compass"

# Inject the bootstrap include into our css:
if USE_BOOTSTRAP
  inject_into_file 'app/assets/stylesheets/application/index.css.scss', <<-CODE, :before=>/.*Custom imports/
// Bootstrap import
//-----------------------------------------
@import 'bootstrap';

//-----------------------------------------
CODE
end



#---------------------------------------------------------------------
# SERVER SETUP
#---------------------------------------------------------------------

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






#---------------------------------------------------------------------
# CREATE A SPLASH PAGE
#---------------------------------------------------------------------

# Just in case:
remove_file 'public/index.html'


file "app/controllers/splash_controller.rb", <<-CODE
class SplashController < ApplicationController

  def index
  end

  def signup
  end

end
CODE


file "app/views/splash/index.html.haml", <<-CODEBLOCK
%main.masthead
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
    .col-lg-8.col-lg-offset-2
      %h1.text-center Thanks for planting this seed!

      %p.lead.text-center Lots of great things just happened! You're not done though. Please follow the instructions below to get this project off to a good start!

      %section
        %h2 Environments
        %p Please set up as many accounts as are necessary for all external services. That usually means development, staging, and production accounts.

        %h4 Development
        %p Place all configuration variables in <code>.env</code>, as in:

        :ruby
          code = <<-CODE
          # .env:
          S3_BUCKET_NAME=development-bucket-name
          AWS_ACCESS_KEY_ID=<development key>
          AWS_SECRET_ACCESS_KEY=<development key>
          CODE
        %pre~ code

        %p There should not be any sensitive information in this file, so it is committed to the repo.


        %h4 Staging
        %p If you're using Heroku, all config variables should be set using `heroku config`, as in:

        %pre $ heroku config:add -a your-app-stage S3_BUCKET_NAME=assets.your-app-stage.herokuapp.com

        %p If you're not using Heroku, you should still be using environment variables for <strong>all</strong> config!

        
        %h4 Production
        %p Same thing. Use environment variables!

        %pre $ heroku config:add -a your-app S3_BUCKET_NAME=assets.your-app.com

      %section
        %h2 Google Analytics Setup

        %p All you have to do is set the <code>GOOGLE_ACCOUNT_ID</code> environment variable for each environment and you're done! Create the accounts and do it now!
  
  
      %section
        %h2 AWS Setup

        %p Start by setting the keys in the <code>.env</code> file if your project uses AWS/S3. Fun fact: If you call your variables <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code>, the <code>aws-sdk</code> gem finds them and configures itself automatically!
  
        %p You should ensure that <strong>the client owns their own AWS account</strong>. That means:
        %ol
          %li The client sets up their account if they don't currently have one
          %li The client sends you credentials
          %li You use AWS Identity and Access Management (IAM) to set up developer accounts and an AWS login page.
          %li The client changes their login password, if desired.
          %li Set up buckets with restricted access keys for all necessary environments. See the Codex <a href="http://codex.happyfuncorp.com/slides/11#1" target="_blank">AWS Setup and Security</a> presentation for a walkthrough and links to the relevant resources.

        Most importantly, ensure that the project <strong>does not end up on the HFC AWS account</strong>.

      %section
        %h2 Bootstrap
        %p Bootstrap is really great! The current version is IE8 compatible. That's worth a lot. It's customizable via Sass and all the footwork is done for you! You just have to edit <code>application/variables.css.scss</code>.
        %p Here's a summary of the CSS setup:
        %dl
          %dt
            %code application/index.css.scss:
          %dd
            %p The CSS entry point that imports all the other css. Variables are shared among any files imported here.

          %dt
            %code application/variables.css.scss:
          %dd
            %p
              A list of custom Sass varialbes accessible to anything imported by in `index.css.scss`. This is where you should puts Bootstrap customizations. You can find a full list of Bootstrap variables at:
              = link_to 'Customize Bootstrap', 'http://getbootstrap.com/customize/', :target=>:_blank

          %dt
            %code application/layout.css.scss:
          %dd
            %p Your custom CSS goes here!

          %dt
            %code application/media_queries.css.scss:
          %dd
            %p
              %span This is where any extra media queries you need should be place. Note that you have access to
              %span= link_to "Bootstrap's media query helpers"
              %span> . Use them!

      %section
        %h2 Other things this template adds

        %h4 HTML5 Boilerplate

        %p HTML5 Boilerplate includes things every project should have like normalize.css, Modernizr, Compass, and a placeholder polyfill for IE. It does some heavy reorganization of your application layout, but it's for the best! Go with it!
        %p
          &rarr; Read more about
          = link_to 'HTML5 Boilerplate', 'http://html5boilerplate.com/', :target=>:_blank



        %h4 This splash page
        %code= '/app/views/splash/index.html.haml'

      %section
        %h2 Improvements?

        %p If you have bug reports or ideas about how this template can be improved, please suggest them on the <a href="https://github.com/sublimeguile/seed/issues" target="_blank">Github issues page</a>! Thanks!

CODEBLOCK


# Style the splash page
append_file 'app/assets/stylesheets/application/layout.css.scss', <<-CODE

.splash .masthead {
  padding-top: 120px;
  padding-bottom: 120px;

  background-color: #1e5799;
  @include filter-gradient(#1e5799, #7db9e8, vertical);
  @include background-image(linear-gradient(top,  #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%));
}  

.splash section {
    margin-bottom: 5em;
}
CODE





file "app/views/splash/signup.js.erb", <<-CODE
alert('signed up!');
CODE

route "post '/signup' => 'splash#signup', as: :splash_signup"
route "root to: 'splash#index'"




#---------------------------------------------------------------------
# GIT SETUP
#---------------------------------------------------------------------
git :init
git add: "."
git commit: "-a -m 'Initial commit'"




#---------------------------------------------------------------------
# ALL DONE
#---------------------------------------------------------------------
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

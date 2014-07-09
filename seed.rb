#---------------------------------------------------------------------
# CONFIG
#---------------------------------------------------------------------

SEED_DIR = ENV['SEED_DIR']

APP_NAME = ARGV[0].humanize

# Always enabled for now. But I'll at least leave it configurable
CSS_FRAMEWORK='bootstrap'

MAILER='mailchimp'

DEVISE=true
HTTP_AUTH=true
FACEBOOK=true

# Ruby setup
file '.ruby-version', <<-CODE
#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}
CODE


#---------------------------------------------------------------------
# HELPER FUNCTIONS
#---------------------------------------------------------------------


def seed_file_content(filename)
  _f = open( File.join(SEED_DIR, filename), 'r' )
  _content = _f.read
  _f.close
  _content
end

def seed_template_content(filename)
  seed_file_content File.join( 'templates', filename )
end

def seed_file( filename )
  file filename, seed_template_content(filename)
end

def seed_append( filename )
  append_file filename, seed_template_content(filename)
end

#---------------------------------------------------------------------
# .ENV SETUP
#---------------------------------------------------------------------
seed_file '.env'


#---------------------------------------------------------------------
# GEM SETUP
#---------------------------------------------------------------------

# Is it proper to go ahead and install non-proeject gems?
#
# Well, we'll at least check and see if they're already accessible just
# to speed things up a bit.
#
#   foreman:   nice for running unicorn/resque easily
#   rdiscount: used by generator to render README.md into the project
#   compass:   not clear if it's actually necessary
#
%w( foreman rdiscount compass ).each do |_gem|
  begin
    print "Checking for [0;32m#{_gem}[0m gem... "
    require _gem
    puts '[0;32minstalled[0m'
  rescue LoadError
    puts '[0;33mnot installed[0m'
    run "gem install #{_gem}"
  end
end


# Because no one likes Turbolinks.
gsub_file "Gemfile", /^#\s*Turbolinks.*$/,'# No one likes Turbolinks.'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,'# gem \'turbolinks\''
gsub_file "app/assets/javascripts/application.js", /\/\/=\s+require\s+turbolinks.*$/, '// require turbolinks'



# Nice to have:
gem 'haml-rails'
gem 'unicorn'
gem 'dotenv-rails', :groups=>[:development, :test]
gem 'rails_12factor'
gem 'meta-tags', :require => 'meta_tags'
run 'bundle install'



# Feels like there's some redundancy here:
gem 'bootstrap-sass' if CSS_FRAMEWORK=='bootstrap'
gem 'compass-rails'
gem 'compass-h5bp', :group=>:assets
gem 'html5-rails'


case MAILER
when 'mailchimp'
  gem 'gibbon'
end


if DEVISE
  gem 'devise'
  run 'bundle install'
end



# Generate html5 boilerplate:
run 'rails generate html5:install'


# Clean up stupid stuff the html5 boilerplate generator has done:

# The last thing we want is important includes buried in the gem somewhere:
run 'rails generate html5:partial --all'

# Not a chance we're letting any config into yaml files:
remove_file 'config/html5_rails.yml'

# Don't even leave the door open for yaml config:
gsub_file 'app/views/application/_javascripts.html.haml', /-# Looks for google_account_id.*\n/, ''
gsub_file 'app/views/application/_javascripts.html.haml', /google_account_id/, "ENV['GOOGLE_ANALYTICS_SITE_ID']"

# You've overstepped your bounds, html5 boilerplate. Please don't set our page titles:
gsub_file "app/views/application/_head.html.haml", /^.*%title.*\n/s, ''
gsub_file "app/views/application/_head.html.haml", /^.*==\s*#\{\s*controller\.controller_name.*\}.*\n/s, ''

inject_into_file 'app/views/application/_head.html.haml', <<-CODE, :before=>/^.*%meta.*description.*\n/s

  = display_meta_tags :site => '#{APP_NAME}'

CODE



# Enable compass:
gsub_file 'app/assets/stylesheets/application/index.css.scss', /\/\/\s*@import 'compass/, "@import 'compass"
inject_into_file 'app/assets/stylesheets/application/index.css.scss', <<-CODE, :after=>/@import 'compass\/css3.*/

@import "compass/layout/sticky-footer";
CODE

# Inject the bootstrap include into our css:
if CSS_FRAMEWORK=='bootstrap'
  inject_into_file 'app/assets/stylesheets/application/index.css.scss',
                   seed_template_content('app/assets/stylesheets/application/index.css.scss'),
                   :before=>/.*Custom imports/

  seed_append 'app/assets/javascripts/application.js'
  seed_append 'app/assets/stylesheets/application/layout.css.scss'

  remove_file 'app/assets/stylesheets/application/variables.css.scss'
  seed_file 'app/assets/stylesheets/application/variables.css.scss'

  remove_file 'app/views/application/_header.html.haml'
  remove_file 'app/views/application/_footer.html.haml'
  remove_file 'app/views/layouts/application.html.haml'
  seed_file 'app/views/application/_header.html.haml'
  seed_file 'app/views/application/_footer.html.haml'
  seed_file 'app/views/layouts/application.html.haml'

  seed_file 'lib/templates/haml/scaffold/_form.html.haml'
  seed_file 'lib/templates/haml/scaffold/edit.html.haml'
  seed_file 'lib/templates/haml/scaffold/index.html.haml'
  seed_file 'lib/templates/haml/scaffold/new.html.haml'
  seed_file 'lib/templates/haml/scaffold/show.html.haml'
end



if HTTP_AUTH
  inject_into_file 'app/controllers/application_controller.rb', seed_template_content('app/controllers/application_controller.rb'), :after=>/protect_from_forgery.*\n/
end

if DEVISE
  run 'rails generate devise:install'
  run 'bundle install'
  run 'rails generate devise User'
  run 'rails generate devise:views'
  
  remove_file 'app/views/devise/registrations/new.html.erb'
  remove_file 'app/views/devise/sessions/new.html.erb'
  remove_file 'app/views/devise/passwords/edit.html.erb'
  remove_file 'app/views/devise/passwords/new.html.erb'

  seed_file 'app/views/devise/registrations/new.html.haml'
  seed_file 'app/views/devise/sessions/new.html.haml'
  seed_file 'app/views/devise/passwords/edit.html.haml'
  seed_file 'app/views/devise/passwords/new.html.haml'
end



#---------------------------------------------------------------------
# SERVER SETUP
#---------------------------------------------------------------------

seed_file 'Procfile'
seed_file '.foreman'
seed_file 'config/unicorn.rb'
seed_file 'config/initializers/assets.rb'


#---------------------------------------------------------------------
# CREATE A SPLASH PAGE
#---------------------------------------------------------------------

remove_file 'public/index.html'
seed_file "app/controllers/splash_controller.rb"
seed_file "app/views/splash/index.html.haml"
seed_file "app/views/splash/_environment_checks.html.haml"
seed_append 'app/assets/stylesheets/application/layout.css.scss'
seed_file "app/views/splash/signup.js.erb"

route "post '/signup' => 'splash#signup', as: :splash_signup"
route "root to: 'splash#index'"

readme = seed_file_content( 'README.md' )
content_html = RDiscount.new( readme ).to_html
file "app/views/splash/_readme.html.erb", RDiscount.new(readme).to_html



if FACEBOOK
  gem 'omniauth-facebook'

  #MigrationGenerator.new.migration_template 'templates/db/migrate/add_authentications_to_users.rb', 'db/migrate/add_authentications_to_users.rb'

end



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
puts "\t$ rake db:migrate\n\n"
puts "\t$ foreman start\n\n"
puts "\t --> http://localhost:3000/"
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

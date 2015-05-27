# For custom domains on github pages
page "CNAME", layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Better markdown support
# set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true
# set :markdown_engine, :redcarpet

activate :autometatags

# Turn this on if you want to make your url's prettier, without the .html
# activate :directory_indexes

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Bootstrap helpers
activate :bh

configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  # Any files you want to ignore:
  ignore '/admin/*'
  ignore '/stylesheets/admin/*'

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/blog/"
end


# This will push to the gh-pages branch of the repo, which will
# host it on github pages (If this is a github repository)
activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
end

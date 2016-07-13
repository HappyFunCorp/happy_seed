class SetupController < ApplicationController
  before_action :require_local!
  layout :false

  def index
    load_generators
    load_specs
    load_docs
    load_packages
  end

  def open
    spec = Bundler.definition.specs[params[:gem]].first
    if spec
      system( "subl #{spec.gem_dir}/ || sublime #{spec.gem_dir}/")
    end

    redirect_to :root
  end
  
  protected

  def require_local!
    unless local_request?
      redirect_to root_url, error: "This information is only available to local requests"
    end
  end

  def local_request?
    Rails.application.config.consider_all_requests_local || request.local?
  end

  def load_specs
    @specs = Bundler.definition.specs.to_a
  end

  def load_docs
    @docs = files
  end

  def load_generators
    @generators = []
    @files = Dir.glob( File.join( $LOAD_PATH.select{ |x| x =~ /happy_seed/}.first, "**", "*_generator.rb" ))
    @files.each do |file|
      require file
      class_name =  file.gsub( /.*\//, "" ).gsub( /.rb/,"" )
      cls = eval "HappySeed::Generators::#{class_name.classify}"
      @generators << cls if cls.respond_to? :fingerprint
    end
  end

  def load_packages
    @packages = []

    @packages << { title: "Splash Page", desc: "This is a basic splash page", gens: ["simple_cms", "roles"] }
    @packages << { title: "Forum Site", desc: "This is a basic splash page", gens: ["simple_cms", "twitter", "react"] }
    @packages << { title: "Ecommerce", desc: "This is a basic splash page", gens: ["simple_cms", "twitter", "react"] }
    @packages << { title: "Photo Sharing", desc: "This is a basic splash page", gens: ["simple_cms", "twitter", "react"] }
  end
  
  def files
    docs = Dir.glob(File.join( Rails.root, "docs/README.*" )).collect do |file|
      name = file.gsub( /.*README.\d\d./, "happy_seed:" ).gsub( /.rdoc/, "" )
      html = RDiscount.new( File.read( file ) ).to_html
      { name: name, html: html }
    end
  end
end

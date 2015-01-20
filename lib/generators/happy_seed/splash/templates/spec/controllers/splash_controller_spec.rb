require 'rails_helper'

RSpec.describe SplashController, :type => :controller do
  after do
    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end

  it "should return the index page" do
    get :index
    expect(response).to render_template( :index )
  end

  it "should not request authentication even if http_auth is set" do
    ENV['HTTP_AUTH_USERNAME'] = "user"
    ENV['HTTP_AUTH_PASSWORD'] = "pass"

    get :index
    expect(response).to render_template( :index )

    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end

  context "with views" do
    render_views
    it "should return the index page with the correct google tracking code" do
      ENV['GOOGLE_ANALYTICS_SITE_ID'] = '123456'

      get :index
      expect( response.body ).to include( "['_setAccount','123456']" )

      ENV['GOOGLE_ANALYTICS_SITE_ID'] = nil
    end
  end

  context "mailing list signup" do
    it "should require mailchimp env to be setup" do
      ENV["MAILCHIMP_SPLASH_SIGNUP_LIST_ID"] = nil
      ENV["MAILCHIMP_API_KEY"] = nil

      xhr :post, :signup

      expect( assigns( :message) ).to include( "environment variables need to be set" )
    end

    it "should talk to mail chimp if the ENV is set" do
      ENV["MAILCHIMP_SPLASH_SIGNUP_LIST_ID"] = "1"
      ENV["MAILCHIMP_API_KEY"] = "1"
      # assign( :gibbon_api, double( "API" ) )

      stub_request(:post, "https://api.mailchimp.com/2.0/lists/subscribe").
        with(:body => "{\"apikey\":\"1\",\"id\":\"1\",\"email\":{\"email\":null},\"double_optin\":true}").
        to_return(:status => 200, :body => "", :headers => {})

      
      xhr :post, :signup, { :email => "wschenk@gmail.com" }

      expect( assigns( :message) ).not_to include( "environment variables need to be set" )

      ENV["MAILCHIMP_SPLASH_SIGNUP_LIST_ID"] = nil
      ENV["MAILCHIMP_API_KEY"] = nil

    end
  end
end

require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    def index
      render body: "aok"
    end
  end

  it "should not have authentication if http_auth env are blank" do
    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil

    get :index
    expect( response ).to be_success
  end

  it "should request authentication if http_auth is set" do
    ENV['HTTP_AUTH_USERNAME'] = "user"
    ENV['HTTP_AUTH_PASSWORD'] = "pass"

    get :index
    expect( response.status ).to eq( 401 )

    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end

  it "should let people through if the correct pass is set" do
    ENV['HTTP_AUTH_USERNAME'] = "user"
    ENV['HTTP_AUTH_PASSWORD'] = "pass"

    credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'user', 'pass'
    request.env['HTTP_AUTHORIZATION'] = credentials

    get :index
    expect( response ).to be_success

    ENV['HTTP_AUTH_USERNAME'] = nil
    ENV['HTTP_AUTH_PASSWORD'] = nil
  end
end

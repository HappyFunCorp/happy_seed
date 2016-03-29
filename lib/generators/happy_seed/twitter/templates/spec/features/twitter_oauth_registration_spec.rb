require 'rails_helper'

feature "TwitterOAuthRegistration", :type => :feature do
  include Warden::Test::Helpers

  before do
    OmniAuth.config.test_mode = true
    sign_out :user
  end

  after do
    Warden.test_reset!
    Rails.application.env_config["omniauth.auth"] = nil
  end

  it "should create a new user for a twitter user" do
    OmniAuth.config.add_mock(:twitter,  {
      uid: '12345',
      info: {
        name: "Will Schenk",
        nickname: "wschenk",
      }
      });

    visit user_twitter_omniauth_callback_path

    i = Identity.first
    expect( i.uid ).to eq( '12345' )
    expect( i.nickname ).to eq( 'wschenk' )
    expect( i.name ).to eq( 'Will Schenk' )

    expect( page.body ).to include( 'Successfully authenticated from Twitter account.' )
  end

  it "should merge the identity if the user already exists" do
    u = create( :user )
    login_as u, scope: :user

    expect( User.count ).to eq(1)
    expect( Identity.count ).to eq(0)

    OmniAuth.config.add_mock(:twitter,  {
      uid: '12345',
      info: {
        name: "Will Schenk",
        nickname: "wschenk",
      }
      });

    visit user_twitter_omniauth_callback_path

    expect( User.count ).to eq(1)
    expect( Identity.count ).to eq(1)

    expect( Identity.first.user_id ).to eq( u.id )
  end
end
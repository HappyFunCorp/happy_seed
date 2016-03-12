require 'rails_helper'

feature "FacebookOAuthRegistration", :type => :feature do
  include Warden::Test::Helpers

  before do
    OmniAuth.config.test_mode = true

    OmniAuth.config.add_mock(:facebook,  {
      uid: '12345',
      info: {
        name: "Will Schenk",
        nickname: "wschenk",
        email: "will@happyfuncorp.com"
      }
      });
  end

  after do
    Warden.test_reset!
    Rails.application.env_config["omniauth.auth"] = nil
  end

  it "should create a new user" do
    visit user_facebook_omniauth_callback_path

    i = Identity.first
    expect( i.uid ).to eq( '12345' )
    expect( i.nickname ).to eq( 'wschenk' )
    expect( i.name ).to eq( 'Will Schenk' )
    expect( i.email ).to eq( 'will@happyfuncorp.com' )
    expect( i.user_id ).to_not be_nil
    expect( i.user.email ).to eq( 'will@happyfuncorp.com' )

    expect( page.body ).to include( 'Successfully authenticated from Facebook account.' )
  end

  it "should merge the identity if the user already exists" do
    u = create( :user )
    login_as u, scope: :user

    expect( User.count ).to eq(1)
    expect( Identity.count ).to eq(0)

    visit user_facebook_omniauth_callback_path

    expect( User.count ).to eq(1)
    expect( Identity.count ).to eq(1)
    u = User.first
    expect( u.email ).to_not eq( 'will@happyfuncorp.com' )

    expect( Identity.first.user_id ).to eq( u.id )
  end

  it "should populate the email address if empty" do
    u = create( :oauth_user )
    login_as u, scope: :user

    expect( User.count ).to eq(1)
    expect( User.first.email ).to_not eq( 'will@happyfuncorp.com' )
    expect( Identity.count ).to eq(0)

    visit user_facebook_omniauth_callback_path

    expect( User.count ).to eq(1)
    expect( Identity.count ).to eq(1)
    u = User.first
    expect( u.email ).to eq( 'will@happyfuncorp.com' )

    expect( Identity.first.user_id ).to eq( u.id )
  end
end
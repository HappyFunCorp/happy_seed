require 'rails_helper'

feature "Invitations", :type => :feature do
  include Warden::Test::Helpers

  it "should only allow logged in users to invite people" do
    visit new_user_invitation_path

    expect( page.body ).to include( "You need to sign in or sign up before continuing." )
  end

  it "should not invite a user that already exists" do
    login_as create( :user, email: "will@happyfuncorp.com" ), scope: :user

    visit new_user_invitation_path

    within "#new_user" do
      fill_in "user_email", with: "will@happyfuncorp.com"
    end

    click_button "Invite User"

    expect( page.body ).to include( "has already been taken" )    
  end

  it "should send an invite to a new user" do
    login_as create( :user ), scope: :user

    visit new_user_invitation_path

    within "#new_user" do
      fill_in "user_email", with: "will@happyfuncorp.com"
    end

    click_button "Invite User"

    expect( page.body ).to include( "An invitation email has been sent" )

    body = ActionMailer::Base.deliveries.last.body

    md = body.encoded.match /(\/users\/invitation\/accept.*?)"/
    if !md
      assert( false, "URL NOT FOUND IN MESSAGE")
    end

    logout

    visit md[1]

    expect( page.body ).to_not include( "You are already signed in." )

    within "#edit_user" do
      fill_in "user_password", with: "1234567890"
      fill_in "user_password_confirmation", with: "1234567890"
    end

    click_button "Add password"

    expect( page.body ).to include( "Your password was set successfully." )
  end
end

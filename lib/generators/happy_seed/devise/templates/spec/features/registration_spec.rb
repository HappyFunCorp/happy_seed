require 'rails_helper'

feature "Registration", :type => :feature do
  it "should let you create a new user" do
    visit new_user_registration_path

    within "#new_user" do
      fill_in "user_email", with: "test@example.com"
      fill_in "user_password", with: "123456789"
      fill_in "user_password_confirmation", with: "123456789"
    end

    click_button "Sign up"

    expect( page.body ).to include( "Welcome! You have signed up successfully." )

    click_link "Profile"
  end

  it "should require a user to have an email address" do
    visit new_user_registration_path

    within "#new_user" do
      # fill_in "user_email", with: "test@example.com"
      fill_in "user_password", with: "123456789"
      fill_in "user_password_confirmation", with: "123456789"
    end

    click_button "Sign up"

    expect( page.body ).to_not include( "Welcome! You have signed up successfully." )
  end  

  it "should let a user change their password if they enter in their existing password" do
    visit new_user_registration_path

    within "#new_user" do
      fill_in "user_email", with: "test@example.com"
      fill_in "user_password", with: "123456789"
      fill_in "user_password_confirmation", with: "123456789"
    end

    click_button "Sign up"

    expect( page.body ).to include( "Welcome! You have signed up successfully." )

    click_link "Profile"

    within "#edit_user" do
      fill_in "user_password", with: "012345678"
      fill_in "user_password_confirmation", with: "012345678"      
    end

    click_button "Update"

    expect( page.body ).to include( "we need your current password to confirm your changes" )

    within "#edit_user" do
      fill_in "user_password", with: "012345678"
      fill_in "user_password_confirmation", with: "012345678"
      fill_in "user_current_password", with: "123456789"
    end

    click_button "Update"

    expect( page.body ).to include( "Your account has been updated successfully." )
  end

  it "following a forgot password link should let you reset your password and log in" do
    user = create :user

    visit new_user_password_path

    within "#new_user" do
      fill_in "user_email", with: user.email
    end

    click_button "Send me reset password instructions"

    expect( page.body ).to include( "You will receive an email with instructions on how to reset your password in a few minutes." )

    body = ActionMailer::Base.deliveries.last.body

    md = body.encoded.match /(\/users\/password\/edit\?reset.*)/
    if !md
      assert( false, "URL NOT FOUND IN MESSAGE")
    end

    visit md[1]

    within "#new_user" do
      fill_in "user_password", with: "new_password"
      fill_in "user_password_confirmation", with: "new_password"
    end

    click_button "Change my password"

    expect( page.body ).to_not include( "Email can't be blank" )

    visit edit_user_registration_path

    expect( page.body ).to include( "Sign Out")

    click_link "Sign Out"

    expect( page.body ).to include( "Signed out successfully." )
    
    visit new_user_session_path

    within "#new_user" do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "new_password"
    end

    click_button "Log in"

    expect( page.body ).to include( "Signed in successfully.")
  end
end

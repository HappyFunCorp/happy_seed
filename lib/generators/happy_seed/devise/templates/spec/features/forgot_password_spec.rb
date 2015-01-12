require 'rails_helper'

feature "ForgotPasswords", :type => :feature do
  it "should reset your password" do
    user = create :user

    visit new_user_password_path

    within "#new_user" do
      fill_in "user_email", with: user.email
    end

    click_button "Send me reset password instructions"

    # puts ActionMailer::Base.deliveries

    body = ActionMailer::Base.deliveries.last.body

    md = /(\/users\/password\/edit\?reset.*)"/.match( body.to_s )
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

    click_button "Sign in"

    expect( page.body ).to include( "Signed in successfully.")
  end
end

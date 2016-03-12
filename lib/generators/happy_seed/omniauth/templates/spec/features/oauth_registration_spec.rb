require 'rails_helper'

feature "OAuthRegistrations", :type => :feature do
  include Warden::Test::Helpers

  after{ Warden.test_reset! }

  it "should require you to be logged in" do
    visit edit_user_registration_path

    expect( page.body ).to include( "You need to sign in or sign up before continuing." )
  end

  describe "oauth users" do
    it "should let you change add an email address without a password the don't have a password" do
      login_as create( :oauth_user ), scope: :user

      visit edit_user_registration_path

      expect( page.body ).to_not include( "You need to sign in or sign up before continuing." )

      within "#edit_user" do
        fill_in "user[email]", with: "email@example.com"
      end

      click_button "Update"

      expect( page.body ).to include( "Your account has been updated successfully")
    end

    it "should let you set your password initially" do
      login_as create( :oauth_user ), scope: :user

      visit edit_user_registration_path

      within "#edit_user" do
        fill_in "user[email]", with: "email@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
      end

      click_button "Update"

      expect( page.body ).to include( "Your account has been updated successfully")

      logout

      visit edit_user_registration_path

      expect( page.body ).to include( "You need to sign in or sign up before continuing." )

      within "#new_user" do
        fill_in "user[email]", with: "email@example.com"
        fill_in "user[password]", with: "password"
      end

      click_button "Log in"

      expect( page.body ).to include( "Signed in successfully." )
    end
  end

  describe "users with passwords" do
    it "should require your current password if you have one set" do
      login_as create( :user ), scope: :user

      visit edit_user_registration_path

      expect( page.body ).to_not include( "You need to sign in or sign up before continuing." )

      within "#edit_user" do
        fill_in "user[email]", with: "email@example.com"
      end

      click_button "Update"

      expect( page.body ).to_not include( "Your account has been updated successfully")
    end
  end
end
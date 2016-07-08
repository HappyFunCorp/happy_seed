require 'rails_helper'

RSpec.describe Identity, :type => :model do
  describe "validations" do
    before( :each ) do
      @user = build :user
    end

    it "should always have a provider and uid" do
      i = Identity.create user: @user
      expect( i ).to_not be_valid

      i = Identity.create user: @user, provider: "test"
      expect( i ).to_not be_valid

      i = Identity.create user: @user, provider: "test", uid: "1"

      expect( i ).to be_valid
    end

    it "should have a unique uid per provider" do
      i = Identity.create user: @user, provider: "test", uid: "1"
      expect( i ).to be_valid

      i = Identity.create user: @user, provider: "other test", uid: "1"
      expect( i ).to be_valid

      i = Identity.create user: @user, provider: "test", uid: "1"
      expect( i ).to_not be_valid
    end
  end

  describe "construction" do
    it "should create an identity from a hash" do
      data = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => '123545'
      })

      i = Identity.find_for_oauth data

      expect( i ).to be_valid

      i2 = Identity.find_for_oauth data

      expect( i.id ).to eq(i2.id)
    end
  end
end
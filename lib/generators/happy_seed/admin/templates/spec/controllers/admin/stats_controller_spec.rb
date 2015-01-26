require 'rails_helper'

RSpec.describe Admin::StatsController, :type => :controller do
  # before( :each ) do
  #   @request.env["devise.mapping"] = Devise.mappings[:admin_user]
  #   # @request.env["warden"] ||= Whatever.new
  # end

  it "should require the scope param" do
    login_with create( :admin_user ), :admin_user

    get :stats, scope: ''
    expect( response.status ).to eq( 422 )
    expect( response.content_type).to eq( "application/json" )
    expect( response.body ).to eq( "{\"errors\":\"scope not set\"}" )
  end

  it "should return data for a logged in user" do
    login_with create( :admin_user ), :admin_user

    get :stats, scope: 'user'
    expect( response.status ).to eq( 200 )
    expect( response.content_type).to eq( "application/json" )
  end

  # it "should return hourly data for user scope" do
  #   start_time = Time.parse "2014-07-19 15:26:48 -0400"

  #   10.times do |t|
  #     create :user, created_at: start_time - (21.minutes * t)
  #   end

  #   sign_in :admin_user, create( :admin_user )

  #   get :stats, scope: 'user'
  #   expect( response.status ).to eq( 200 )
  #   expect( response.content_type).to eq( "application/json" )
  #   expect( response.body ).to eq("[[\"2014-07-19 16:00:00 UTC\",3],[\"2014-07-19 17:00:00 UTC\",2],[\"2014-07-19 18:00:00 UTC\",3],[\"2014-07-19 19:00:00 UTC\",2]]")
  # end
end

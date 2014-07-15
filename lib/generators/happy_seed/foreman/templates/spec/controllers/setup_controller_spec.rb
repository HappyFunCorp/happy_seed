require 'rails_helper'

RSpec.describe SetupController, :type => :controller do
  it "should return setup information for local requests" do
    get :index
    expect(response).to render_template( :index )
  end

  it "should redirect to root url for non-local requests" do
    @request.remote_addr = "1.1.1.1"
    prev = Rails.configuration.consider_all_requests_local
    Rails.configuration.consider_all_requests_local = false
    get :index
    expect(response).to redirect_to( root_url )
    Rails.configuration.consider_all_requests_local = prev
  end
end

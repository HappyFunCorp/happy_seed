require 'rails_helper'

RSpec.describe "Setup", type: :request do
  describe "GET /setups" do
    it "Renders the setup page locally" do
      get setup_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Mailer Previews")
    end
  end
end

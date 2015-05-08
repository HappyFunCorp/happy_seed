require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Configuration' do
  header 'AUTHORIZATION', :token

  let(:user) { FactoryGirl.create :user_with_token }
  let(:token) { ActionController::HttpAuthentication::Token.encode_credentials user.user_tokens.first.try(:token), installation_identifier: user.user_tokens.first.try(:installation_identifier) }

  get '/v1/configuration', format: :json do
    example_request 'show' do
      response_json = JSON.parse response_body

      expect(status).to eq(200)
      expect(response_json['pusher']['url']).to eq(Rails.application.secrets.pusher_url)
      expect(response_json['aws']['access_key_id']).to eq(Rails.application.secrets.aws_access_key_id)
      expect(response_json['aws']['secret_access_key']).to eq(Rails.application.secrets.aws_secret_access_key)
      expect(response_json['aws']['s3_bucket']).to eq(Rails.application.secrets.s3_bucket)
    end
  end
end
require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Token' do
  let(:user) { FactoryGirl.create :user_with_token }

  post '/v1/token', format: :json do
    before { user.user_tokens.destroy }

    parameter :email, 'Email', required: true, scope: :user
    parameter :password, 'Password', required: true, scope: :user

    let(:email) { user.email }
    let(:password) { user.password }

    example_request 'sign in' do
      response_json = JSON.parse response_body

      expect(response_headers['Content-Type']).to eq('application/json; charset=utf-8')
      expect(status).to eq(200)
      expect(response_json['user_token']).to have_key('access_token')
      expect(response_json['user_token']).to have_key('user')
    end

    example 'sign in with wrong email', document: false do
      do_request params.tap { |parameters| parameters['user']['email'] = Faker::Internet.free_email }
      response_json = JSON.parse response_body

      expect(status).to eq(404)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('email')
    end

    example 'sign in with wrong password', document: false do
      do_request params.tap { |parameters| parameters['user']['password'] = Faker::Lorem.characters 8 }
      response_json = JSON.parse response_body

      expect(status).to eq(403)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('password')
    end
  end

  delete '/v1/token', format: :json do
    header 'AUTHORIZATION', :token
    let(:token) { ActionController::HttpAuthentication::Token.encode_credentials user.user_tokens.first.try :access_token }

    example_request 'sign out' do
      response_json = JSON.parse response_body

      expect(status).to eq(200)
      expect(response_json['user_token']).to have_key('access_token')
      expect(response_json['user_token']).to have_key('user')
    end
  end
end

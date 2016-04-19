require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Token' do
  let(:user) { FactoryGirl.create :user_with_token }

  post '/v1/token', format: :json do
    parameter :email, 'Email', required: true, scope: :user_token
    parameter :password, 'Password', required: true, scope: :user_token
    parameter :installation_identifier, 'Unique Installation Identifier', required: true, scope: :user_token
    parameter :form_factor, 'smartphone tablet10 tablet7 desktop', required: true, scope: :user_token
    parameter :os, 'ios android bb wp7', required: true, scope: :user_token

    let(:email) { user.email }
    let(:password) { user.password }
    let(:installation_identifier) { Faker::Lorem.characters 10 }
    let(:form_factor) { %w(smartphone tablet10 tablet7 desktop).sample }
    let(:os) { %w(ios android bb wp7).sample }

    example_request 'sign in' do
      response_json = JSON.parse response_body

      expect(response_headers['Content-Type']).to eq('application/json; charset=utf-8')
      expect(status).to eq(200)
      expect(response_json['user_token']).to have_key('token')
      expect(response_json['user_token']).to have_key('user')
    end

    example 'sign in with wrong email', document: false do
      do_request params.tap { |parameters| parameters['user_token']['email'] = Faker::Internet.free_email }
      response_json = JSON.parse response_body

      expect(status).to eq(404)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('email')
    end

    example 'sign in with wrong password', document: false do
      do_request params.tap { |parameters| parameters['user_token']['password'] = Faker::Lorem.characters 8 }
      response_json = JSON.parse response_body

      expect(status).to eq(403)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('password')
    end

    example 'sign in without installation identifier', document: false do
      do_request params.tap { |parameters| parameters['user_token']['installation_identifier'] = nil }
      response_json = JSON.parse response_body

      expect(status).to eq(422)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('installation_identifier')
    end
  end

  delete '/v1/token', format: :json do
    header 'AUTHORIZATION', :token
    let(:token) { ActionController::HttpAuthentication::Token.encode_credentials user.user_tokens.first.try(:token), installation_identifier: user.user_tokens.first.try(:installation_identifier) }

    example_request 'sign out' do
      response_json = JSON.parse response_body

      expect(status).to eq(200)
      expect(response_json['user_token']).to have_key('token')
      expect(response_json['user_token']).to have_key('user')
    end
  end
end
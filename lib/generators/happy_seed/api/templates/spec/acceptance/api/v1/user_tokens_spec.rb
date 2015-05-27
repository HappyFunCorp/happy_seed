require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Token' do
  let(:user) { FactoryGirl.create :user_with_token }

  post '/v1/token', format: :json do
    parameter :email, 'Email', required: true, scope: :user_token
    parameter :password, 'Password', required: true, scope: :user_token
    parameter :installation_identifier, 'Unique Installation Identifier', required: true, scope: :user_token
    parameter :push_token, 'Unique push token', required: true, scope: :user_token
    parameter :form_factor, 'smartphone tablet10 tablet7 desktop', required: true, scope: :user_token
    parameter :os, 'ios android bb wp7', required: true, scope: :user_token

    let(:email) { user.email }
    let(:password) { user.password }
    let(:installation_identifier) { Faker::Lorem.characters 10 }
    let(:push_token) { Faker::Lorem.characters 10 }
    let(:form_factor) { %w(smartphone tablet10 tablet7 desktop).sample }
    let(:os) { %w(ios android bb wp7).sample }

    example_request 'sign in' do
      response_json = JSON.parse response_body

      expect(response_headers['Content-Type']).to eq('application/json; charset=utf-8')
      expect(status).to eq(200)
      expect(response_json['user_token']).to have_key('token')
      expect(response_json['user_token']['push_token']).to eq(push_token)
      expect(response_json['user_token']).to have_key('user')
    end

    example 'sign in with wrong email', document: false do
      do_request params.tap { |parameters| parameters['user_token']['email'] = Faker::Internet.free_email }
      response_json = JSON.parse response_body

      expect(status).to eq(404)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('email')
    end

    # example 'sign in with locked user', document: false do
    #   user.lock_access! send_instructions: false
    #   do_request
    #   response_json = JSON.parse response_body

    #   expect(status).to eq(403)
    #   expect(response_json['id']).to be_nil
    #   expect(response_json['errors']).to have_key('user')
    # end

    example 'sign in with wrong password', document: false do
      do_request params.tap { |parameters| parameters['user_token']['password'] = Faker::Lorem.characters 8 }
      response_json = JSON.parse response_body

      expect(status).to eq(403)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('password')
    end

    example 'sign in without installation identifier', document: false do
      do_request params.tap { |parameters| parameters['user_token'].delete 'installation_identifier' }
      response_json = JSON.parse response_body

      expect(status).to eq(422)
      expect(response_json['id']).to be_nil
      expect(response_json['errors']).to have_key('installation_identifier')
    end
  end

  put '/v1/token', format: :json do
    header 'AUTHORIZATION', :token

    parameter :push_token, 'Unique push token', required: true, scope: :user_token

    let(:token) { ActionController::HttpAuthentication::Token.encode_credentials user.user_tokens.first.try(:token), installation_identifier: user.user_tokens.first.try(:installation_identifier) }
    let(:push_token) { Faker::Lorem.characters 10 }

    example_request 'update' do
      explanation 'At the moment, only push token can be updated'
      response_json = JSON.parse response_body

      expect(status).to eq(200)
      expect(response_json['user_token']['push_token']).to eq(push_token)
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
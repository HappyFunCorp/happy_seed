require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
  let(:user) { FactoryGirl.build :user_with_token }

  post '/v1/users', format: :json do
    parameter :email, 'Email', required: true, scope: :user
    parameter :password, 'Password', required: true, scope: :user

    let(:email) { user.email }
    let(:password) { user.password }

    example_request 'sign up' do
      response_json = JSON.parse response_body

      expect(status).to eq(201)
      expect(response_json['user_token']).to have_key('access_token')
      expect(response_json['user_token']).to have_key('user')
    end

    example 'sign up error', document: false do
      do_request params.tap { |parameters| parameters['user']['email'] = nil }
      response_json = JSON.parse response_body

      expect(status).to eq(422)
      expect(response_json['errors']).to have_key('email')
    end
  end

  post '/v1/users/forgot_password', format: :json do
    before { user.save }

    parameter :email, 'Email', required: true, scope: :user
    let(:email) { user.email }

    example_request 'forgot password' do
      response_json = JSON.parse response_body

      expect(status).to eq 200
      expect(response_json['user']['email']).to eq(email)
    end
  end

  put '/v1/users/reset_password', format: :json do
    before { user.save }

    parameter :reset_password_token, 'Reset password token', required: true, scope: :user
    parameter :password, 'Password', required: true, scope: :user
    parameter :password_confirmation, 'Password confirmation', required: true, scope: :user

    let(:reset_password_token) { user.send :set_reset_password_token }
    let(:password) { Faker::Internet.password 8 }
    let(:password_confirmation) { password }

    example_request 'reset password' do
      response_json = JSON.parse response_body

      expect(status).to eq 200
      expect(response_json['user']).to have_key('id')
    end
  end

  get '/v1/users/:id', format: :json do
    before { user.save }

    header 'AUTHORIZATION', :token

    parameter :id, 'User Unique Identifier', required: true

    let(:token) { ActionController::HttpAuthentication::Token.encode_credentials user.user_tokens.first.try(:access_token) }
    let(:id) { user.id }

    example_request 'show' do
      response_json = JSON.parse response_body

      expect(status).to eq 200
      expect(response_json['user']).to have_key('id')
    end
  end
end

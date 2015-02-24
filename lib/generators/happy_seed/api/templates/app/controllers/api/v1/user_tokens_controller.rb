class Api::V1::UserTokensController < Api::V1::BaseController
  before_action :requires_authentication_token, only: %w(update destroy)

  def create
    respond_to do |format|
      user = User.where('LOWER(email) = ?', user_token_params[:email].try(:downcase)).first
      if user.present?
        if user.valid_password?(user_token_params[:password])
          if user.active_for_authentication?
            user_token = user.user_tokens.where(installation_identifier: user_token_params[:installation_identifier]).first_or_initialize
            user_token.update push_token: user_token_params[:push_token]
            user_token.update form_factor: user_token_params[:form_factor]
            user_token.update os: user_token_params[:os]
            if user_token.persisted?
              format.json do
                render json: {user_token: user_token_hash(user_token, user: true)}, status: :ok
              end
            else
              format.json do
                render json: {errors: user_token.errors}, status: :unprocessable_entity
              end
            end
          else
            format.json do
              render json: {errors: {user: 'is locked'}}, status: :forbidden
            end
          end
        else
          format.json do
            render json: {errors: {password: 'is invalid'}}, status: :forbidden
          end
        end
      else
        format.json do
          render json: {errors: {email: 'not found'}}, status: :not_found
        end
      end
    end
  end

  def update
    respond_to do |format|
      if current_user_token.try(:persisted?)
        if current_user_token.update(user_token_params.slice :push_token)
          format.json do
            render json: {user_token: user_token_hash(current_user_token)}, status: :ok
          end
        else
          format.json do
            render json: {errors: current_user_token.errors}, status: :unprocessable_entity
          end
        end
      else
        format.json do
          render json: {errors: {token: 'not found'}}, status: :not_found
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user_token.try(:persisted?)
        current_user_token.destroy
        format.json do
          render json: {user_token: user_token_hash(current_user_token, user: true)}, status: :ok
        end
      else
        format.json do
          render json: {errors: {token: 'not found'}}, status: :not_found
        end
      end
    end
  end

  private

  def user_token_params
    params[:user_token].permit :email, :password, :installation_identifier, :push_token, :form_factor, :os
  end
end
class Api::V1::UserTokensController < Api::V1::BaseController
  before_action :requires_authentication_token, only: %w(update destroy)

  def create
    respond_to do |format|
      user = User.where('LOWER(email) = ?', user_params[:email].try(:downcase)).first
      if user.present?
        if user.valid_password?(user_params[:password])
          if user.active_for_authentication?
            user_token = user.user_tokens.create
            if user_token.persisted?
              format.json do
                render json: { user_token: user_token_hash(user_token, user: true) }, status: :ok
              end
            else
              format.json do
                render json: { errors: user_token.errors }, status: :unprocessable_entity
              end
            end
          else
            format.json do
              render json: { errors: { user: 'is locked' } }, status: :forbidden
            end
          end
        else
          format.json do
            render json: { errors: { password: 'is invalid' } }, status: :forbidden
          end
        end
      else
        format.json do
          render json: { errors: { email: 'not found' } }, status: :not_found
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user_token.try(:persisted?)
        current_user_token.destroy
        format.json do
          render json: { user_token: user_token_hash(current_user_token, user: true) }, status: :ok
        end
      else
        format.json do
          render json: { errors: { token: 'not found' } }, status: :not_found
        end
      end
    end
  end

  private

  def user_params
    params[:user].permit :email, :password
  end
end

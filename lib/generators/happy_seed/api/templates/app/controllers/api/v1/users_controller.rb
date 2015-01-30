class Api::V1::UsersController < API::V1::BaseController
  before_action :requires_authentication_token, except: %w(create forgot_password reset_password)
  before_action :set_user, only: %w(show update)

  def show
    respond_to do |format|
      if @user.present?
        format.json do
          render json: {user: user_hash(@user)}, status: :ok
        end
      else
        format.json do
          render json: {errors: {id: 'not found'}}, status: :not_found
        end
      end
    end
  end

  def create
    respond_to do |format|
      user = User.new user_params
      if user.save
        user_token = user.user_tokens.where(installation_identifier: user_token_params[:installation_identifier]).first_or_create
        if user_token.persisted?
          format.json do
            render json: {user_token: user_token_hash(user_token, user: true)}, status: :created
          end
        else
          format.json do
            render json: {errors: user_token.errors}, status: :unprocessable_entity
          end
        end
      else
        format.json do
          render json: {errors: user.errors}, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @user.present?
        if @user.update(user_params)
          format.json do
            render json: {user: user_hash(@user)}, status: :ok
          end
        else
          format.json do
            render json: {errors: @user.errors}, status: :unprocessable_entity
          end
        end
      else
        format.json do
          render json: {errors: {id: 'not found'}}, status: :not_found
        end
      end
    end
  end

  def invite
    respond_to do |format|
      invited = user_params[:invited].select { |i| i[:email].present? }
      format.json do
        if invited.present?
          current_user.invite invited
          render json: {user: {invited: invited}}, status: :ok
        else
          current_user.errors.add :invited, 'is empty'
          render json: {errors: current_user.errors}, status: :unprocessable_entity
        end
      end
    end
  end

  def forgot_password
    respond_to do |format|
      user = User.where(email: user_params[:email]).first
      format.json do
        if user.present?
          user.reset_password_and_notify
          render json: {user: user_hash(user).slice(:email)}, status: :ok
        else
          render json: {errors: {email: 'not found'}}, status: :not_found
        end
      end
    end
  end

  def reset_password
    respond_to do |format|
      user = User.reset_password_by_token user_params.slice(:reset_password_token, :password, :password_confirmation)
      format.json do
        if user.present?
          if user.errors.empty?
            render json: {user: user_hash(user)}, status: :ok
          else
            render json: {errors: user.errors}, status: :unprocessable_entity
          end
        else
          render json: {errors: {email: 'not found'}}, status: :not_found
        end
      end
    end
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first
  end

  def user_params
    params[:user].permit :email, :password, :username, :full_name, :avatar, :reset_password_token, :password_confirmation, invited: %w(email full_name).map(&:to_sym)
  end

  def user_token_params
    params[:user_token].permit :installation_identifier
  end
end
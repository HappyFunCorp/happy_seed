class Api::V1::BaseController < ApplicationController
  include ModelHash

  attr_accessor :current_user, :current_user_token, :installation_identifier

  protected

  def set_user
    @user = params[:user_id].present? ? User.where(id: params[:user_id]).first : nil
  end

  def requires_authentication_token
    authenticate_or_request_with_http_token do |token, options|
      self.installation_identifier = options[:installation_identifier]
      self.current_user_token = UserToken.where(token: token, installation_identifier: installation_identifier).first
      self.current_user = sign_in(:user, current_user_token.user) if current_user_token.try(:user).present?
      current_user.present? ? (current_user_token.try(:touch); true) : false
    end
  end
end
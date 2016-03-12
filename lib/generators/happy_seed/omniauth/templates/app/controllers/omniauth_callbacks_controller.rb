class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def generic_callback( provider )
    @identity = Identity.find_for_oauth request.env["omniauth.auth"]

    @user = @identity.user || current_user

    if @user.nil?
      @user = User.create( email: @identity.email, oauth_callback: true )
      @identity.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @identity.email
      @user.update_attribute( :email, @identity.email)
    end

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
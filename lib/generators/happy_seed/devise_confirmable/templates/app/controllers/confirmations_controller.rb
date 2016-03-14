class ConfirmationsController < Devise::ConfirmationsController
  # Signin automatically if they come in through the link
  def show
    super do
      if resource.errors.empty?
        sign_in(resource) 
      end
    end
  end
end
class DevisePreview < ActionMailer::Preview
  if User.devise_modules.include? :confirmable
    def confirmation_instructions
      Devise::Mailer.confirmation_instructions(user, "tokentokentoken")
    end
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(user, "tokentokentoken")
  end

  if User.devise_modules.include? :lockable
    def unlock_instructions
      Devise::Mailer.unlock_instructions(user, "tokentokentoken")
    end
  end

  if User.devise_modules.include? :invitable
    def invitation_instructions
      Devise::Mailer.invitation_instructions(user, "tokentokentoken")
    end
  end

  protected
    def user
      User.first || User.new( email: "will@happyfuncorp.com" )
    end
end
class DevisePreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(user, "tokentokentoken")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(user, "tokentokentoken")
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(user, "tokentokentoken")
  end

  def invitation_instructions
    Devise::Mailer.invitation_instructions(user, "tokentokentoken")
  end

  def user
    User.first || User.new( email: "will@happyfuncorp.com" )
  end
end
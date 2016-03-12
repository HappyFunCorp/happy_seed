class DevisePreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, "tokentokentoken")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "tokentokentoken")
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(User.first, "tokentokentoken")
  end
end
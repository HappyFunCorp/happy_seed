module Api::V1::ModelHash
  def user_hash(user)
    {
        id: user.id,
        email: user.email,
        push_token: user.push_token
    }
  end

  def user_token_hash(user_token, *args)
    options = args.extract_options!
    output = {
        token: user_token.token
    }
    output.update(user: user_hash(user_token.user)) if true == options[:user]
    output
  end
end
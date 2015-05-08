module Api::V1::ModelHash
  def configuration_hash
    {
        pusher: {
            url: Rails.application.secrets.pusher_url
        },
        aws: {
            access_key_id: Rails.application.secrets.aws_access_key_id,
            secret_access_key: Rails.application.secrets.aws_secret_access_key,
            s3_bucket: Rails.application.secrets.s3_bucket
        }
    }
  end

  def user_hash(user)
    {
        id: user.id,
        login: user.login,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name
    }
  end

  def user_token_hash(user_token, *args)
    options = args.extract_options!
    output = {
        token: user_token.token,
        push_token: user_token.push_token
    }
    output.update(user: user_hash(user_token.user)) if true == options[:user]
    output
  end
end
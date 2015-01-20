class GoogleAppsClient
  def initialize( client )
    @client = client
  end

  def self.client( identity )
    client = Google::APIClient.new(:application_name => 'HappySeed App', :application_version => "1.0.0" )
    client.authorization.update_token!({:access_token => identity.accesstoken, :refresh_token => identity.refreshtoken})
    GoogleAppsClient.new( client )
  end

  def admin_api
    @admin_api ||= @client.discovered_api("admin", "directory_v1")
  end

  def list_users( domain = "happyfuncorp.com" )
    request = { api_method: admin_api.users.list }
    request[:parameters] = { domain: domain }
    @client.execute request
  end

  def is_valid_user?( email, domain = "happyfuncorp.com" )
    users = list_users( domain )
    users.data['users'].each do |user|
      if user['primaryEmail'].downcase == email.downcase
        return true
      end
    end
    return false
  end

  def ensure_user( email, first_name, last_name )
    if !is_valid_user?( email )
      new_user = admin_api.users.insert.request_schema.new({
        'password' => 'happiness4u',
        'primaryEmail' => email,
        'name' => {
          'familyName' => last_name,
          'givenName' => first_name
        },
        changePasswordAtNextLogin: true
      })

      result = @client.execute(
        :api_method => admin_api.users.insert,
        :body_object => new_user
      )
    end
  end

  def list_groups( domain = "happyfuncorp.com" )
    request = { api_method: admin_api.groups.list }
    request[:parameters] = { domain: domain }
    @client.execute request
  end

  def list_members( group_key )
    request = { api_method: admin_api.members.list }
    request[:parameters] = { groupKey: group_key }
    @client.execute request
  end
end
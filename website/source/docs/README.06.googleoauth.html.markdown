HappySeed Google Oauth Install
====================

### What does this do?

The `happy_seed:googleoauth` depends upon `happy_seed:omniauth` and

* Installs googleauth authentication
* Creates a sub client in lib/google_api_client that uses googles default stuff

### Why do you want this?

If you want to have the user connect via google, this is the one line command for it.

### Environment Variables

```
GOOGLE_OAUTH2_APP_ID=
GOOGLE_OAUTH2_APP_SECRET=
```

### What needs to be done?

In config/initializers/devise.rb make sure that the scope you are requesting is correct.

Since you need to set the callbacks as urls, you'll need to create one app for local development and another app for production.  (Possibly one for staging as well.)

- Go to 'https://console.developers.google.com'
- Select your project.
- Click 'APIs & auth'
- Go to credentials
- Create new client ID
- Call back is http://localhost:3000/users/auth/google_oauth2/callback
- Make sure "Contacts API" and "Google+ API" are on.
- Go to Consent Screen, and provide an 'EMAIL ADDRESS' and a 'PRODUCT NAME'
- Wait 10 minutes for changes to take effect.

Once you have the client connected, then you need to discover the API.

```
client = user.google_oauth2_client
admin_api = client.discovered_api("admin", "directory_v1")

request = { api_method: admin_api.users.list }
request[:parameters] = { domain: "happyfuncorp.com" }
response = client.execute request
```
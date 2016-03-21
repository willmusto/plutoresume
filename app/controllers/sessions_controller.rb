require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class SessionsController < ApplicationController
  def create
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive',
      # Input here name of your site
      # e.g https://www.my-site.com/auth/google/oauth2/callback
      # don't forget to enter the last part: '/auth/google/oauth2/callback'
      # :redirect_uri => 'http://localhost:3000/auth/google_oauth2/callback'
      :redirect_uri => 'https://salty-beach-57778.herokuapp.com/auth/google_oauth2/callback'
      )
    if request['code'] == nil
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to(auth_uri)
    else
      auth_client.code = request['code']
      auth_client.fetch_access_token!
      auth_client.client_secret = nil
      session[:credentials] = auth_client.to_json
      redirect_to('/resume/new#')
    end
  end

  def destroy
  	# Log out the user. NOTE: User can again log in without typing password.
  	# This is because he is still logged into his Google account. Log out of
  	# Google to type in the password again.
  	session[:user_id] = nil
  	redirect_to root_path
  end
end

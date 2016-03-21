OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  
  # provider :google_oauth2, '1062941081130-a93jdilnmjv5m5hnnot89eeiu9be0ma7.apps.googleusercontent.com', 'JnK-RUfWxlnI6frbTIjEjAUd', {
  # 	scope: ['drive',
  # 		'https://www.googleapis.com/auth/drive'],
  # 		access_type: 'offline'}
  	# Tell Google we want to access only user's basic info
  	# scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online'
    # provider :google_oauth2, '1062941081130-a93jdilnmjv5m5hnnot89eeiu9be0ma7.apps.googleusercontent.com', 'JnK-RUfWxlnI6frbTIjEjAUd', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
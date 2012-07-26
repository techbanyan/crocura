Rails.application.config.middleware.use OmniAuth::Builder do

	instagram_credentials_file = File.join(Rails.root,'config','instagram_credentials.yml')
	raise "#{instagram_credentials_file} is missing!" unless File.exists? instagram_credentials_file
	instagram_credentials = YAML.load_file(instagram_credentials_file)[Rails.env].symbolize_keys

  	provider :instagram, instagram_credentials[:CLIENT_ID], instagram_credentials[:CLIENT_SECRET], {:scope => 'likes comments'}

	OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)
end
Instagram.configure do |config|
	instagram_credentials_file = File.join(Rails.root,'config','instagram_credentials.yml')
	raise "#{instagram_credentials_file} is missing!" unless File.exists? instagram_credentials_file
	instagram_credentials = YAML.load_file(instagram_credentials_file)[Rails.env].symbolize_keys
  	config.client_id = instagram_credentials[:CLIENT_ID]
  	config.client_secret = instagram_credentials[:CLIENT_SECRET]
end
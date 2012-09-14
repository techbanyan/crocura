# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Crocura::Application.initialize!

Rails::Initializer.run do |config|
  config.middleware.use "NoWWW" if RAILS_ENV == "production"
end

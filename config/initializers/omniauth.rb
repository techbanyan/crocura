Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, '1cd7f7b1702343398850dbae7c9def2a', 'a37b1b98852a42b5b1bad48d69add6aa'
end
Unsplash.configure do |config|    
  config.application_id     = ENV['UNSPLASH_APP_ID']    
  config.application_secret = ENV['UNSPLASH_APP_SECRET']
  config.application_redirect_uri = ENV['UNSPLASH_APP_CALLBACK']
end
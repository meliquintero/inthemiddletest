SacsRuby.configure do |config|
  config.user_id = '6ky0vw4cvqeyk629' # User ID
  config.group = 'DEVCENTER' # Group
  config.domain = 'EXT' # Domain
  config.client_secret = 'O1PIaea7' # Client Secret
  config.environment = 'https://api.test.sabre.com' # Environment
  config.token_strategy = :single # or :shared - see Token paragraph
end

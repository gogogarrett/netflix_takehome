api_config_lookup = Rails.application.config_for(:api_config)

Rails.application.configure do
  config.api_config = ActiveSupport::OrderedOptions.new
  config.api_config.dates_service = api_config_lookup["dates_service"].symbolize_keys
  config.api_config.titles_service = api_config_lookup["titles_service"].symbolize_keys
  config.api_config.thumbnails_service  = api_config_lookup["thumbnails_service"].symbolize_keys
end

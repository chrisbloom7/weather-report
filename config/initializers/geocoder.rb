Geocoder.configure(
  lookup: :nominatim,  # Free, no API Key needed but rate limited to 1 req/sec
  http_headers: { "User-Agent" => "weather-report" },
  timeout: 5,
  logger: ActiveSupport::Logger.new($stdout)
)

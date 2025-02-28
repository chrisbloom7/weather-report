Geocoder.configure(
  lookup: :nominatim,  # Free alternative (or use :google with an API key)
  http_headers: { "User-Agent" => "weather-report" },
  timeout: 5
)

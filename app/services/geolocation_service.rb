class GeolocationService
  DEFAULT_PARAMS = { countrycodes: "us,ca" }.freeze

  def self.get_autocomplete_locations(location)
    Geocoder.search(location, params: DEFAULT_PARAMS)
  rescue StandardError => e
    Rails.logger.error("Geolocation Error: #{e.message}")
    []
  end

  def self.get_location(location)
    get_autocomplete_locations(location).first
  rescue StandardError => e
    Rails.logger.error("Geolocation Error: #{e.message}")
    nil
  end
end

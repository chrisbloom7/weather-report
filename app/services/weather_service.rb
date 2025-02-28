require "faraday"
require "json"
require "faraday/logging/color_formatter"

class WeatherService
  BASE_URL = "https://api.openweathermap.org"
  API_URL = "/data/2.5/weather"
  API_KEY = ENV["OPENWEATHER_API_KEY"]

  def self.fetch_weather(location)
    return nil unless location
    response = connection.get(API_URL, lat: location.latitude, lon: location.longitude, appid: API_KEY, units: "imperial")
    JSON.parse(response.body).merge("location" => location.data) if response.success?
  rescue Faraday::Error => e
    Rails.logger.error("Weather API Error: #{e.message}")
    nil
  end

  private

  def self.connection
    Faraday.new(url: BASE_URL) do |faraday|
      faraday.response :logger, ActiveSupport::Logger.new($stdout), formatter: Faraday::Logging::ColorFormatter
    end
  end
end

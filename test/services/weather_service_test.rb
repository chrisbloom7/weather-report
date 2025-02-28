require "test_helper"
require "faraday"
require "json"

class WeatherServiceTest < ActiveSupport::TestCase
  setup do
    @location = OpenStruct.new(latitude: 40.7128, longitude: -74.0060, data: { "city" => "New York" })
    @response_body = { "weather" => "sunny", "main" => { "temp" => 75 } }.to_json
  end

  test "fetch_weather returns weather data for a valid location" do
    stub_request(:get, "#{WeatherService::BASE_URL}#{WeatherService::API_URL}")
      .with(query: { lat: @location.latitude, lon: @location.longitude, appid: WeatherService::API_KEY, units: "imperial" })
      .to_return(status: 200, body: @response_body, headers: { "Content-Type" => "application/json" })

    weather_data = WeatherService.fetch_weather(@location)
    assert_not_nil weather_data
    assert_equal "sunny", weather_data["weather"]
    assert_equal 75, weather_data["main"]["temp"]
    assert_equal @location.data, weather_data["location"]
  end

  test "fetch_weather returns nil for an invalid location" do
    weather_data = WeatherService.fetch_weather(nil)
    assert_nil weather_data
  end

  test "fetch_weather handles API errors gracefully" do
    stub_request(:get, "#{WeatherService::BASE_URL}#{WeatherService::API_URL}")
      .with(query: { lat: @location.latitude, lon: @location.longitude, appid: WeatherService::API_KEY, units: "imperial" })
      .to_return(status: 500, body: "", headers: { "Content-Type" => "application/json" })

    weather_data = WeatherService.fetch_weather(@location)
    assert_nil weather_data
  end
end

class WeatherController < ApplicationController
  def index
  end

  def show
    location = GeolocationService.get_location(params[:location])
    cached_data = nil # Rails.cache.read("weather:#{location.postal_code}") unless location.nil?
    if cached_data
      @weather = JSON.parse(cached_data)
      @cached = true
    else
      @weather = WeatherService.fetch_weather(location)
      Rails.cache.write("weather:#{location.postal_code}", @weather.to_json, expires_in: 30.minutes) if @weather
      @cached = false
    end
  end
end

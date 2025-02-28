require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = OpenStruct.new(postal_code: "10001", latitude: 40.7128, longitude: -74.0060, data: { "city" => "New York" })
    @weather_data = { "weather" => [ { "main" => "Sunny", "description" => "sunny" } ], "main" => { "temp" => 75 }, "location" => @location.data }
    Rails.cache.clear
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should show weather with cached data" do
    Rails.cache.write("weather:#{@location.postal_code}", @weather_data.to_json, expires_in: 30.minutes)
    refute_nil Rails.cache.read("weather:#{@location.postal_code}")

    GeolocationService.stub :get_location, @location do
      get weather_url(location: "New York")
      assert_response :success
      assert_equal @weather_data, assigns(:weather)
      assert assigns(:cached)
    end
  end

  test "should show weather with fresh data" do
    GeolocationService.stub :get_location, @location do
      WeatherService.stub :fetch_weather, @weather_data do
        get weather_url(location: "New York")
        assert_response :success
        assert_equal @weather_data, assigns(:weather)
        assert_not assigns(:cached)
      end
    end
  end

  test "should handle missing location" do
    GeolocationService.stub :get_location, nil do
      get weather_url(location: "Unknown")
      assert_response :success
      assert_nil assigns(:weather)
    end
  end
end

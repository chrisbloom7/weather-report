require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @query = "New York"
    @location_results = [
      OpenStruct.new(address: "New York, NY, USA", latitude: 40.7128, longitude: -74.0060),
      OpenStruct.new(address: "Newark, NJ, USA", latitude: 40.7357, longitude: -74.1724)
    ]
  end

  test "should return empty array for blank query" do
    get locations_autocomplete_url, params: { query: "" }
    assert_response :success
    assert_equal [], JSON.parse(response.body)
  end

  test "should return location results for valid query" do
    GeolocationService.stub :get_autocomplete_locations, @location_results do
      get locations_autocomplete_url, params: { query: @query }
      assert_response :success
      results = JSON.parse(response.body)
      assert_equal 2, results.size
      assert_equal "New York, NY, USA", results.first["address"]
      assert_equal 40.7128, results.first["lat"]
      assert_equal -74.0060, results.first["lon"]
    end
  end

  test "should handle geolocation service errors gracefully" do
    GeolocationService.stub :get_autocomplete_locations, [] do
      get locations_autocomplete_url, params: { query: @query }
      assert_response :success
      assert_equal [], JSON.parse(response.body)
    end
  end
end

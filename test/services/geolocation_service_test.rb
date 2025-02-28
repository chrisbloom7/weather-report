require "test_helper"

class GeolocationServiceTest < ActiveSupport::TestCase
  setup do
    @location_query = "New York"
    @location_result = OpenStruct.new(address: "New York, NY, USA", latitude: 40.7128, longitude: -74.0060)
    @autocomplete_results = [
      OpenStruct.new(address: "New York, NY, USA", latitude: 40.7128, longitude: -74.0060),
      OpenStruct.new(address: "Newark, NJ, USA", latitude: 40.7357, longitude: -74.1724)
    ]
  end

  test "get_location returns the first result for a valid location query" do
    Geocoder.stub :search, [ @location_result ] do
      location = GeolocationService.get_location(@location_query)
      assert_not_nil location
      assert_equal @location_result.address, location.address
      assert_equal @location_result.latitude, location.latitude
      assert_equal @location_result.longitude, location.longitude
    end
  end

  test "get_location returns nil for an invalid location query" do
    Geocoder.stub :search, [] do
      location = GeolocationService.get_location(@location_query)
      assert_nil location
    end
  end

  test "get_location handles exceptions gracefully" do
    Geocoder.stub :search, ->(_) { raise StandardError.new("Geocoder error") } do
      location = GeolocationService.get_location(@location_query)
      assert_nil location
    end
  end

  test "get_autocomplete_locations returns results for a valid location query" do
    Geocoder.stub :search, @autocomplete_results do
      results = GeolocationService.get_autocomplete_locations(@location_query)
      assert_not_nil results
      assert_equal 2, results.size
      assert_equal @autocomplete_results.first.address, results.first.address
    end
  end

  test "get_autocomplete_locations handles exceptions gracefully" do
    Geocoder.stub :search, ->(_) { raise StandardError.new("Geocoder error") } do
      results = GeolocationService.get_autocomplete_locations(@location_query)
      assert_empty results
    end
  end
end

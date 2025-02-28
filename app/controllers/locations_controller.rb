class LocationsController < ApplicationController
  def autocomplete
    query = params[:query]
    return render json: [] if query.blank?

    results = GeolocationService.get_autocomplete_locations(query).map do |location|
      { address: location.address, lat: location.latitude, lon: location.longitude }
    end

    render json: results
  end
end

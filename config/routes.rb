Rails.application.routes.draw do
  root "weather#index"
  get "/weather", to: "weather#show"

  get "locations/autocomplete", to: "locations#autocomplete"
end

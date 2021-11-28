Rails.application.routes.draw do
  defaults format: :json do
    get 'prefs'  => 'prefs#get_pref_all'
    get 'cities' => 'cities#get_city_all'
    
    get 'datetimes' => 'datetimes#get_datetimes'

    get 'nicknames' => 'favorites#get_nicknames'
    get '/favorites/by/:nickname' => 'favorites#get_favorites_by_nickname'
    post 'favorites' => 'favorites#post_favorites'
    
    get '/weather_to/:city_code' => 'weather#get_weather_to_by_citycode'

  end
end

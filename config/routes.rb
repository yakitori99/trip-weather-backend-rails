Rails.application.routes.draw do
  defaults format: :json do
    get 'prefs'  => 'prefs#get_pref_all'
    get 'cities' => 'cities#get_city_all'
    
    get 'datetimes' => 'datetimes#get_datetimes'

    get 'nicknames' => 'favorites#get_nicknames'
    get '/favorites/by/:nickname' => 'favorites#get_favorites_by_nickname'
    
  end
end

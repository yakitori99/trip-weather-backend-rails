Rails.application.routes.draw do
  defaults format: :json do
    get 'prefs'  => 'prefs#get_pref_all'
    get 'cities' => 'cities#get_city_all'
    
    get 'datetimes' => 'datetimes#get_datetimes'

    resources :favorites
    
  end
end

Rails.application.routes.draw do
  defaults format: :json do
    get 'prefs'  => 'prefs#get_pref_all'
    get 'cities' => 'cities#get_city_all'
    
    resources :favorites
    
  end
end

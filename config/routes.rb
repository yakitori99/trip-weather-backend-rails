Rails.application.routes.draw do
  resources :favorites
  resources :cities
  get 'prefs' => 'prefs#get_pref_all'
end

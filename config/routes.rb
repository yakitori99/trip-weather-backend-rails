Rails.application.routes.draw do
  defaults format: :json do
    resources :favorites
    resources :cities
    get 'prefs' => 'prefs#get_pref_all'
  end
end

json.array! @cities do |city|
  json.extract! city, :city_code, :city_name, :pref_code, :city_lon, :city_lat
end

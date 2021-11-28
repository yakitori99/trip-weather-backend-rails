class WeatherController < ApplicationController
  include GetWeatherApi
  
  # CityCodeを用いてTo(目的地)の予想天気を取得
  def get_weather_to_by_citycode
    # 都市情報を取得
    @city = City.where("city_code = ?", params[:city_code]).first
    # 都市の緯度経度を用いて、8日分(今日+7日間)の天気予報を取得
    weather_infos = get_weather_forecast(@city.city_lon, @city.city_lat, 8)

    render json: weather_infos
  end

end

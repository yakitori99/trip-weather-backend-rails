class WeatherController < ApplicationController
  include GetWeatherApi
  
  # CityCodeを用いてTo(目的地)の予想天気を取得
  def get_weather_to_by_citycode
    # 都市情報を取得
    city = City.where("city_code = ?", params[:city_code]).first
    # 都市の緯度経度を用いて、8日分(今日+7日間)の天気予報を取得
    weather_infos = get_weather_forecast(city.city_lon, city.city_lat, 8)

    render json: weather_infos
  end

  # CityCodeを用いてFrom(現在地)の昨日の天気と今日の予想天気を取得
  def get_weather_from_by_citycode
    # 都市情報を取得
    city = City.where("city_code = ?", params[:city_code]).first
    
    # 並列処理でAPI問い合わせを行う
    # Parallel.mapを用いることで、処理終了順に関わらずループ処理順で値を受け取り可能
    weather_infos = Parallel.map([0, 1], :in_threads=>2) {|i|
      if i==0
        # 都市の緯度経度を用いて、昨日の天気を取得
        weather_infos_yesterday = get_weather_yesterday(city.city_lon, city.city_lat)
        weather_infos_yesterday[0]
      elsif i==1
        # 都市の緯度経度を用いて、今日の天気予報を取得
        weather_infos_today = get_weather_forecast(city.city_lon, city.city_lat, 1)
        weather_infos_today[0]
      end
    }

    render json: weather_infos
  end

end

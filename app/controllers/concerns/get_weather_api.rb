module GetWeatherApi
  # OpenWeatherMapAPI
  WEATHER_API_BASEURL = "https://api.openweathermap.org"
  WEATHER_API_FORECAST_ADDURL = "/data/2.5/onecall"
  WEATHER_API_TIMEMACHINE_ADDURL = "/data/2.5/onecall/timemachine"
  WEATHER_API_UNITS = "metric"
	WEATHER_API_LANG  = "ja"

  API_OPEN_TIMEOUT_SEC = 3
  API_TIMEOUT_SEC = 5

  # longitude(経度), latitude(緯度), 天気予報取得日数を受け取り、APIに問い合わせて天気予報を返す関数
  def get_weather_forecast(lon, lat, get_day_num)
    # タイムアウト時間を指定し、コネクションを作成
    conn = Faraday.new(WEATHER_API_BASEURL, request: {
      open_timeout: API_OPEN_TIMEOUT_SEC, # sec opening a connection
      timeout: API_TIMEOUT_SEC # sec waiting for response
    })
    # APIパラメータを指定
    params = {
      lat:  lat,
      lon:  lon,
      appid:PrivateConfig::API_KEY,
      units:WEATHER_API_UNITS,
      lang: WEATHER_API_LANG,
    }
    # API get
    res = conn.get(WEATHER_API_FORECAST_ADDURL, params)
    # jsonをパース
    res_hash = JSON.parse(res.body)

    # hashから戻り値用arrayへ代入
    # array of hash[DateTimeStr, MaxTemp, MinTemp, WeatherCode]
    weather_infos = []
    for i in 0..get_day_num-1
      daily_info = res_hash["daily"][i]
      
      this_hash = {}
      this_hash["DateTimeStr"] = Time.at(daily_info["dt"]).strftime("%Y/%m/%d %H:%M:%S")
      this_hash["MaxTemp"] = daily_info["temp"]["max"]
      this_hash["MinTemp"] = daily_info["temp"]["min"]
      this_hash["WeatherCode"] = daily_info["weather"][0]["id"]
      
      weather_infos.push(this_hash)
    end

    return weather_infos
  end

end
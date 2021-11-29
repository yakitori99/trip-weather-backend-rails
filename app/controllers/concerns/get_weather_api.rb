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

  # longitude(経度), latitude(緯度)を受け取り、APIに問い合わせて昨日の天気情報を返す関数
  def get_weather_yesterday(lon, lat)

    # グリニッジ標準時における昨日を表すunix_timeを生成
    time_yesterday = Time.now.utc - 1.days + 9.hours
    unix_time_yesterday = time_yesterday.to_i

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
      dt: unix_time_yesterday,
    }
    # API get
    res = conn.get(WEATHER_API_TIMEMACHINE_ADDURL, params)
    # jsonをパース
    res_hash = JSON.parse(res.body)

    # res_hashのhourly情報をもとに、daily情報を取得
    yesterday_str = Time.at(res_hash["hourly"][0]["dt"]).strftime("%Y/%m/%d %H:%M:%S")
    max_temp = -100.0
    min_temp = 100.0
    weather_codes = []
    res_hash["hourly"].each_with_index do |hourly_info, i|
      # 気温
      temp = hourly_info["temp"]
      if temp > max_temp
        max_temp = temp
      end
      if temp < min_temp
        min_temp = temp
      end
      # 天気コードをarrayへ代入
      if weather_codes.length < Constants::WEATHER_CHECK_LENGTH
        weather_codes.push(hourly_info["weather"][0]["id"])
      end

    end

    # hourlyの天気からdailyの天気を判定
    daily_weather_code = get_daily_weather_code_from_hourly(weather_codes)

    # 戻り値用hashを作成し、戻り値用arrayへ代入
    return_hash = {}
    return_hash["DateTimeStr"] = yesterday_str
    return_hash["MaxTemp"] = max_temp
    return_hash["MinTemp"] = min_temp
    return_hash["WeatherCode"] = daily_weather_code
    # array of hash[DateTimeStr, MaxTemp, MinTemp, WeatherCode]
    weather_infos = [return_hash]  

    return weather_infos
  end

  
  private
  # HourlyのweatherCodes(array of int)から、ロジックに従いDailyのweatherCode(int)を返す関数
  def get_daily_weather_code_from_hourly(weather_codes)
    # 1桁判定用のarray
    weather_codes_one = []
    for weather_code in weather_codes
      weather_codes_one.push(weather_code/100)
    end

    # 判定
    daily_weather_code = -1
    for row in Constants::WEATHER_CODE_THRESHS
      check_code = row[0]
      out_code   = row[1]
      thresh     = row[2]
      if check_code <= 9
        # 1桁で判定
        num = weather_codes_one.count(check_code)
      else
        # 3桁で判定
        num = weather_codes.count(check_code)
      end
      if num >= thresh
        daily_weather_code = out_code
        break
      end
    end
    # ここまでで天気が決まらない場合、曇りとみなす
    if daily_weather_code == -1
      daily_weather_code = Constants::WEATHER_CODE_CLOUDS
    end
    
    return daily_weather_code
  end

end
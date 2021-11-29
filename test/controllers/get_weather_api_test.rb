require "test_helper"

class GetWeatherApiTest < ActionDispatch::IntegrationTest
  include GetWeatherApi

  test "should get_weather_forecast" do
    city_code = '130010'
    
    get_day_nums = [1, 4, 8]
    
    time_now = Time.zone.now

    for get_day_num in get_day_nums
      # 都市情報を取得
      @city = City.where("city_code = ?", city_code).first
      # 都市の緯度経度を用いて、8日分(今日+7日間)の天気予報を取得
      weather_infos = get_weather_forecast(@city.city_lon, @city.city_lat, get_day_num)

      # 件数が正しいことを確認
      assert_equal(get_day_num, weather_infos.length)

      for i in 0..get_day_num-1
        # 日付と日付の型、ソート順が正しいことを確認
        assert_equal((time_now + i.days).strftime("%Y/%m/%d"), weather_infos[i]["DateTimeStr"][0..9])
        
        # 型チェック
        assert_equal(true, weather_infos[i]["MaxTemp"].is_a?(Float))
        assert_equal(true, weather_infos[i]["MinTemp"].is_a?(Float))
        assert_equal(true, weather_infos[i]["WeatherCode"].is_a?(Integer))
      end
    end

  end


  test "should get_weather_yesterday" do
    city_codes = ['130010', '016010']    
    time_now = Time.zone.now
    
    for city_code in city_codes
      # 都市情報を取得
      @city = City.where("city_code = ?", city_code).first
      # 都市の緯度経度を用いて、昨日の天気を取得
      weather_infos = get_weather_yesterday(@city.city_lon, @city.city_lat)

      # 件数が正しいことを確認
      assert_equal(1, weather_infos.length)
      
      # 日付と日付の文字列形式が正しいことを確認
      assert_equal((time_now - 1.days).strftime("%Y/%m/%d"), weather_infos[0]["DateTimeStr"][0..9])
      
      # 型チェック
      assert_equal(true, weather_infos[0]["MaxTemp"].is_a?(Float))
      assert_equal(true, weather_infos[0]["MinTemp"].is_a?(Float))
      assert_equal(true, weather_infos[0]["WeatherCode"].is_a?(Integer))
    end

  end


  test "should get_daily_weather_code_from_hourly" do
    weather_codes_array = [
      [600, 601, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 201, 211], # Snow:600
      [501, 501, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 201, 211], # Thunderstorm:200
      [600, 201, 500, 501, 502, 800, 800, 800, 800, 800, 800, 800, 800, 800, 800], # Rain:501
      [600, 201, 500, 501, 801, 801, 801, 801, 801, 801, 800, 800, 800, 800, 800], # Clear:800
      [600, 201, 500, 501, 801, 801, 801, 801, 801, 802, 800, 800, 800, 800, 802], # few clouds:801
      [500, 500, 801, 801, 801, 801, 800, 800, 800, 800, 802, 802, 802, 802, 802], # scattered clouds:802
      [500, 500, 801, 801, 801, 801, 800, 800, 800, 800, 802, 802, 802, 802, 803], # clouds:803
      [701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701], # clouds:803
    ]
    expected_array = [
      600,
      200,
      501,
      800,
      801,
      802,
      803,
      803,
    ]

    weather_codes_array.zip(expected_array) do |weather_codes, expected|
      # hourlyからdailyのweather_codeを判定
      daily_weather_code = get_daily_weather_code_from_hourly(weather_codes)
      # 期待値と一致するかチェック
      assert_equal(expected, daily_weather_code)
    end
    
  end

end

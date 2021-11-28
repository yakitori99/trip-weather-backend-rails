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

end

require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest

  test "should get_weather_to_by_citycode" do
    city_codes = ['130010', '474020']

    for city_code in city_codes
      get '/weather_to/' + city_code
      
      # ステータスコードが期待値どおりか確認
      assert_response :success

      # API戻り値をパース
      res = JSON.parse(@response.body)
      # 件数が正しいことを確認
      assert_equal(8, res.length)

      time_now = Time.zone.now
      for i in 0..7
        # 日付と日付の型、ソート順が正しいことを確認
        assert_equal((time_now + i.days).strftime("%Y/%m/%d"), res[i]["DateTimeStr"][0..9])
        
        # 型チェック
        assert_equal(true, res[i]["MaxTemp"].is_a?(Float))
        assert_equal(true, res[i]["MinTemp"].is_a?(Float))
        assert_equal(true, res[i]["WeatherCode"].is_a?(Integer))
      end
      
    end

  end
  
end

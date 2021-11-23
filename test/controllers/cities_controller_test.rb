require "test_helper"

class CitiesControllerTest < ActionDispatch::IntegrationTest

  test "should get_city_all" do
    get cities_url, as: :json

    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(res.length, 142)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal(res[0]["CityCode"] , "011000")
    assert_equal(res[45]["CityCode"] , "130010")
    assert_equal(res[141]["CityCode"], "474020")
    # 値を確認
    assert_equal(res[45]["CityName"], "東京")
    assert_equal(res[45]["CityLon"], 139.691711)
    assert_equal(res[45]["CityLat"], 35.689499)

    assert_response :success
  end
  
end

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
    assert_equal("011000", res[0]["CityCode"])
    assert_equal("130010", res[45]["CityCode"])
    assert_equal("474020", res[141]["CityCode"])
    # 値を確認
    assert_equal("東京", res[45]["CityName"])
    assert_equal(139.691711, res[45]["CityLon"])
    assert_equal(35.689499,  res[45]["CityLat"])

    assert_response :success
  end
  
end

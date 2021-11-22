require "test_helper"

class PrefsControllerTest < ActionDispatch::IntegrationTest

  test "should get_pref_all" do
    get prefs_url, as: :json
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(res.length, 47)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal(res[0]["PrefCode"] , "01")
    assert_equal(res[12]["PrefCode"] , "13")
    assert_equal(res[46]["PrefCode"], "47")
    # 値を確認
    assert_equal(res[46]["PrefName"], "沖縄県")

    assert_response :success
  end

end

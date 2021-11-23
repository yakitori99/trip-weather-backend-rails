require "test_helper"

class PrefsControllerTest < ActionDispatch::IntegrationTest

  test "should get_pref_all" do
    get prefs_url, as: :json
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(47, res.length)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal("01", res[0]["PrefCode"])
    assert_equal("13", res[12]["PrefCode"])
    assert_equal("47", res[46]["PrefCode"])
    # 値を確認
    assert_equal("沖縄県", res[46]["PrefName"], )

    assert_response :success
  end

end

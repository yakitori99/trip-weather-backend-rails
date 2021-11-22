require "test_helper"

class PrefsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get prefs_url, as: :json
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(res.length, 47)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal(res[0]["pref_code"] , "01")
    assert_equal(res[12]["pref_code"] , "13")
    assert_equal(res[46]["pref_code"], "47")

    assert_response :success
  end

end

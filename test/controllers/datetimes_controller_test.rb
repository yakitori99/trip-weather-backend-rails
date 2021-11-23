require "test_helper"

class DatetimesControllerTest < ActionDispatch::IntegrationTest

  test "should get_datetimes" do
    get datetimes_url, as: :json
    # API戻り値をパース
    res = JSON.parse(@response.body)
    p(res)

    # 件数が正しいことを確認
    assert_equal(res.length, 9)

    assert_response :success
  end

end

require "test_helper"

class PrefsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pref = prefs(:one)
  end

  test "should get index" do
    get prefs_url, as: :json
    assert_response :success
  end

  test "should create pref" do
    assert_difference('Pref.count') do
      post prefs_url, params: { pref: { pref_code: @pref.pref_code, pref_name: @pref.pref_name } }, as: :json
    end

    assert_response 201
  end

  test "should show pref" do
    get pref_url(@pref), as: :json
    assert_response :success
  end

  test "should update pref" do
    patch pref_url(@pref), params: { pref: { pref_code: @pref.pref_code, pref_name: @pref.pref_name } }, as: :json
    assert_response 200
  end

  test "should destroy pref" do
    assert_difference('Pref.count', -1) do
      delete pref_url(@pref), as: :json
    end

    assert_response 204
  end
end

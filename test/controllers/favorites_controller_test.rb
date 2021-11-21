require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @favorite = favorites(:one)
  end

  test "should get index" do
    get favorites_url, as: :json
    assert_response :success
  end

  test "should create favorite" do
    assert_difference('Favorite.count') do
      post favorites_url, params: { favorite: { from_city_code: @favorite.from_city_code, from_pref_code: @favorite.from_pref_code, nickname: @favorite.nickname, to_city_code: @favorite.to_city_code, to_pref_code: @favorite.to_pref_code } }, as: :json
    end

    assert_response 201
  end

  test "should show favorite" do
    get favorite_url(@favorite), as: :json
    assert_response :success
  end

  test "should update favorite" do
    patch favorite_url(@favorite), params: { favorite: { from_city_code: @favorite.from_city_code, from_pref_code: @favorite.from_pref_code, nickname: @favorite.nickname, to_city_code: @favorite.to_city_code, to_pref_code: @favorite.to_pref_code } }, as: :json
    assert_response 200
  end

  test "should destroy favorite" do
    assert_difference('Favorite.count', -1) do
      delete favorite_url(@favorite), as: :json
    end

    assert_response 204
  end
end

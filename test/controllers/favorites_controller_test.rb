require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get_nicknames" do
    get nicknames_url, as: :json
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(3, res.length)

    # ソート順、値が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal("", res[0]["Nickname"])
    assert_equal("ryo", res[1]["Nickname"])
    assert_equal("たなか", res[2]["Nickname"])

    assert_response :success
  end

  # ニックネームなしの場合のテスト
  test "should get_favorites_by_nickname 1" do
    get '/favorites/by/no_nickname_selected'
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(3, res.length)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal("170010", res[0]["FromCityCode"])
    assert_equal("040010", res[1]["FromCityCode"])
    assert_equal("011000", res[2]["FromCityCode"])

    # 値が正しいことを確認
    assert_equal("", res[0]["Nickname"])
    assert_equal("石川県", res[0]["FromPrefName"])
    assert_equal("金沢", res[0]["FromCityName"])
    assert_equal("福井県", res[0]["ToPrefName"])
    assert_equal("福井", res[0]["ToCityName"])
    assert_equal("2021/09/21 02:58:30", res[0]["UpdatedAt"])

    assert_response :success
  end

  # ニックネームがローマ字の場合のテスト
  test "should get_favorites_by_nickname 2" do
    get '/favorites/by/ryo'
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(2, res.length)

    # ソート順が正しいことを確認
    # assert_equal(expected, actual, [msg])
    assert_equal("130010", res[0]["FromCityCode"])
    assert_equal("270000", res[1]["FromCityCode"])

    # 値が正しいことを確認
    assert_equal("ryo", res[0]["Nickname"])
    assert_equal("東京都", res[0]["FromPrefName"])
    assert_equal("東京", res[0]["FromCityName"])
    assert_equal("北海道", res[0]["ToPrefName"])
    assert_equal("札幌", res[0]["ToCityName"])
    assert_equal("2021/09/12 22:01:13", res[0]["UpdatedAt"])

    assert_response :success
  end

  # ニックネームが全角文字の場合のテスト
  test "should get_favorites_by_nickname 3" do
    # 全角文字をURLに含めるためにエンコード（エスケープ）
    url = '/favorites/by/' + CGI.escape('たなか')
    get url
    # API戻り値をパース
    res = JSON.parse(@response.body)
    # 件数が正しいことを確認
    assert_equal(1, res.length)

    # 値が正しいことを確認
    assert_equal("たなか", res[0]["Nickname"])
    assert_equal("東京都", res[0]["FromPrefName"])
    assert_equal("東京", res[0]["FromCityName"])
    assert_equal("東京都", res[0]["ToPrefName"])
    assert_equal("東京", res[0]["ToCityName"])
    assert_equal("2021/09/21 02:58:30", res[0]["UpdatedAt"])

    assert_response :success
  end
  
  # setup do
  #   @favorite = favorites(:one)
  # end

  # test "should get index" do
  #   get favorites_url, as: :json
  #   assert_response :success
  # end

  # test "should create favorite" do
  #   assert_difference('Favorite.count') do
  #     post favorites_url, params: { favorite: { from_city_code: @favorite.from_city_code, from_pref_code: @favorite.from_pref_code, nickname: @favorite.nickname, to_city_code: @favorite.to_city_code, to_pref_code: @favorite.to_pref_code } }, as: :json
  #   end

  #   assert_response 201
  # end

  # test "should show favorite" do
  #   get favorite_url(@favorite), as: :json
  #   assert_response :success
  # end

  # test "should update favorite" do
  #   patch favorite_url(@favorite), params: { favorite: { from_city_code: @favorite.from_city_code, from_pref_code: @favorite.from_pref_code, nickname: @favorite.nickname, to_city_code: @favorite.to_city_code, to_pref_code: @favorite.to_pref_code } }, as: :json
  #   assert_response 200
  # end

  # test "should destroy favorite" do
  #   assert_difference('Favorite.count', -1) do
  #     delete favorite_url(@favorite), as: :json
  #   end

  #   assert_response 204
  # end
end

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
    # ステータスコードが期待値どおりか確認
    assert_response :success
  end

  ## get_favorites_by_nickname
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
    # ステータスコードが期待値どおりか確認
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
    # ステータスコードが期待値どおりか確認
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
    # ステータスコードが期待値どおりか確認
    assert_response :success
  end

  ## post_favorites
  # 正常系
  test "should post_favorites 1" do
    params_array = [
      # INS
      ["山田", "130010", "280010"],
      ["山田", "130010", "280020"],
      ["yamada", "110010", "120010"],
      ["", "180010", "190010"],
      # UPD1
      ["山田", "130010", "280010"],
      ["山田", "130010", "280020"],
      ["yamada", "110010", "120010"],
      ["", "180010", "190010"],
      # UPD2
      ["山 　田", "130010", "280010"],
      ["山田", "130010", "280020"],
      [" y a mada　", "110010", "120010"],
      [" 　", "180010", "190010"],
    ]
    expected_array = [1,1,1,1, 2,2,2,2, 2,2,2,2]

    params_array.zip(expected_array) do |params, expected|
      # POST
      post favorites_url params: { nickname: params[0], from_city_code: params[1], to_city_code: params[2]}, as: :json
      # API戻り値をパース
      res = JSON.parse(@response.body)
      
      # 値が期待値どおりか確認
      assert_equal(expected, res["ResultCode"])
      # ステータスコードが期待値どおりか確認
      assert_response(201)
    end

    # 一応DB登録結果を出力
    names = ["山田","yamada", "no_nickname_selected"]
    for name in names
      url = '/favorites/by/' + CGI.escape(name)
      get url
      res = JSON.parse(@response.body)
      p(res)
    end

  end

  # 異常系
  test "should post_favorites 2" do
    params_array = [
      # 存在しないcity_codeの場合
      ["山田", "990010", "280010"],
      ["山田", "130010", "990020"],
      ["", "18001",  "190010"],
      ["", "180010", "19001"],
    ]

    for params in params_array
      # POST
      post favorites_url params: { nickname: params[0], from_city_code: params[1], to_city_code: params[2]}, as: :json
            
      # ステータスコードが期待値どおりか確認
      assert_response(400)
    end

  end
  
  # 異常系
  test "should post_favorites 3" do
    params_array = [
      # 不正なkeyの場合
      ["山田", "990010", "280010"],
    ]

    for params in params_array
      # POST
      post favorites_url params: { nickname: params[0], fromCityCode: params[1], to_city_code: params[2]}, as: :json
            
      # ステータスコードが期待値どおりか確認
      assert_response(400)
    end

  end

end

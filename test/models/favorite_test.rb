require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  
  test "ins_upd_favorites" do
    params_array = [
      # INS
      ["山田", "130010", "280010"],
      ["山田", "130010", "280020"],
      # UPD
      ["山田", "130010", "280010"],
      ["山田", "130010", "280020"],
      # ERR
      ["山田", "130010", "280019"],
      ["山田", "990010", "280020"],
    ]
    expected_array = [1,1, 2,2, -1,-1]

    equal_array = [true, true, false, false, nil, nil]

    params_array.each_index do |i|
      # 変数準備
      params = params_array[i]
      expected = expected_array[i]
      equal_flag = equal_array[i]
      nickname = params[0]
      from_city_code = params[1]
      to_city_code = params[2]
      
      # テスト対象の処理
      result_code = Favorite.ins_upd_favorites(nickname, from_city_code, to_city_code)
      
      ## 処理結果チェック
      # result_codeが期待値どおりか確認
      assert_equal(expected, result_code)

      favorites = Favorite.where("nickname = ? AND from_city_code = ? AND to_city_code = ?",
                                  nickname, from_city_code, to_city_code).to_a
      # 正常系
      if expected > 0        
        # 1件であること
        assert_equal(1,favorites.length)
        favorite = favorites[0]
        
        # created_atとupdated_atの値を比較
        assert_equal(equal_flag, favorite.created_at == favorite.updated_at)
        # prefとcityの関係を確認
        assert_equal(favorite.from_city_code[0..1], favorite.from_pref_code)
        assert_equal(favorite.to_city_code[0..1], favorite.to_pref_code)
      else
        # 異常系
        # 0件であること(INSされていないこと)
        assert_equal(0,favorites.length)
      end

      
    end
  end
end

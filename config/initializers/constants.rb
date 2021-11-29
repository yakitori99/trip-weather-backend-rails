# 共通定数を定義するモジュール
module Constants
  # 空文字をURL末尾に含められないため,以下の特殊文字列を空文字の代わりに利用する
  NO_NICKNAME = "no_nickname_selected"

  # favoritesテーブルへのINS/UPD結果を表すコード
  FAVORITES_DONE_CODE_ERR = -1
  FAVORITES_DONE_CODE_INS = 1
  FAVORITES_DONE_CODE_UPD = 2

  ## Weather関連定数
  # 9-23時
  WEATHER_CHECK_LENGTH = 15
  # 普通の曇り
  WEATHER_CODE_CLOUDS = 803

  # hourlyからdailyのweather_codeを判定するための配列
  # weatherCode と 判定するしきい値のセット。hourlyのweather_codeを上から順に評価し、条件を満たしたらそこで終了
  # 以下のチェック用コードが1桁の場合、例えば条件が5なら、codeが5XXのいずれでも条件を満たすとみなす
  WEATHER_CODE_THRESHS  = [
    # チェック用、output用Code, 個数のしきい値
    [6, 600, 2],   # Snow
    [2, 200, 2],   # Thunderstorm
    [5, 501, 3],   # Rain
    [800, 800, 5], # Clear 晴れ
    [801, 801, 5], # few clouds 晴れ時々曇り
    [802, 802, 5], # scattered clouds 晴れ時々曇り
  ]
  
end
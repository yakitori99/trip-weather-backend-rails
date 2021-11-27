# 共通定数を定義するモジュール
module Constants
  # 空文字をURL末尾に含められないため,以下の特殊文字列を空文字の代わりに利用する
  NO_NICKNAME = "no_nickname_selected"

  # favoritesテーブルへのINS/UPD結果を表すコード
  FAVORITES_DONE_CODE_ERR = -1
  FAVORITES_DONE_CODE_INS = 1
  FAVORITES_DONE_CODE_UPD = 2
end
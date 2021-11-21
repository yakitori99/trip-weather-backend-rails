class CreatePrefs < ActiveRecord::Migration[6.1]
  def change
    create_table :prefs do |t|
      t.text :pref_code
      t.text :pref_name

      t.timestamps
    end
  end
end

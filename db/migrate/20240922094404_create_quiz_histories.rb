class CreateQuizHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_histories do |t|
      t.references :user, null: false, foreign_key: true # ユーザーが存在する ＝ログインしないと履歴が保存されない
      t.references :location1, null: false, foreign_key: { to_table: :locations }
      t.references :location2, null: false, foreign_key: { to_table: :locations }
      t.float :user_answer, null: false
      t.float :correct_answer, null: false
      t.boolean :is_correct, null: false
      t.datetime :answered_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :quiz_histories, [:user_id, :answered_at] # ユーザーごとの回答履歴を表示しやすくする
  end
end

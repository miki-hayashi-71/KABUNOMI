class AddIndexToQuizHistoriesOnUserIdAndCreatedAt < ActiveRecord::Migration[7.1]
  def change
    # user_id と created_at カラムの組み合わせでインデックスを追加
    add_index :quiz_histories, [:user_id, :created_at]
  end
end

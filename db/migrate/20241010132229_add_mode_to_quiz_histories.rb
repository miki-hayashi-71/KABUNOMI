class AddModeToQuizHistories < ActiveRecord::Migration[7.1]
  def up
    # 一旦modeカラムをnull:trueで追加。modeカラムを追加したら既存のレコードはmodeがnullのため
    add_column :quiz_histories, :mode, :text, null: true
    # 既存のレコードにデフォルト値を設定する
    execute "UPDATE quiz_histories SET mode = 'simple'"
    # null: false制約を追加
    change_column :quiz_histories, :mode, :text, null: false
  end

  def down
    # modeカラムを削除する
    remove_column :quiz_histories, :mode
  end
end

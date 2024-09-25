class CreateChallengeResults < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_results do |t|
      t.references :user, null: false, foreign_key: true # ログイン必須
      t.integer :total_questions, null: false, default: 10
      t.integer :correct_answers, null: false, default: 0

      t.timestamps
    end
  end
end

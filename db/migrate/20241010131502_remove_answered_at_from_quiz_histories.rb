class RemoveAnsweredAtFromQuizHistories < ActiveRecord::Migration[7.1]
  def change
    remove_column :quiz_histories, :answered_at, :datetime
  end
end

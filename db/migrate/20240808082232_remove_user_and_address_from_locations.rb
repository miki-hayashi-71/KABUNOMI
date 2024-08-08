class RemoveUserAndAddressFromLocations < ActiveRecord::Migration[7.1]
  def change
    remove_reference :locations, :user, null: false, foreign_key: true
    remove_column :locations, :address, :string
  end
end

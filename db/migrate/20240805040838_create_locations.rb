class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :address
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end

    add_index :locations, [:latitude, :longitude], unique: true
  end
end

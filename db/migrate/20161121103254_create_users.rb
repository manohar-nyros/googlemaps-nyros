class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :city
      t.string :country
      t.string :picture
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end

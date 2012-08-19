class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.text :data
      t.string :number

      t.timestamps
    end
    add_index :photos, :number
  end
end

class CreateUserStreamPhotos < ActiveRecord::Migration
  def change
    create_table :user_stream_photos do |t|
      t.text :data
      t.string :number
      t.integer :user_id

      t.timestamps
    end
    add_index :user_stream_photos, :number
    add_index :user_stream_photos, :user_id
  end
end

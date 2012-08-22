class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.string :query
      t.string :query_type
      t.float :latitude
      t.float :longitude
      t.integer :rank
      t.timestamps
    end
  end
end

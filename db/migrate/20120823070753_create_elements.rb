class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.text :privacy
      t.text :help
      t.text :faq
      t.text :how_it_works
      t.text :about

      t.timestamps
    end
  end
end

class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string  :name
      t.string  :slug
      t.boolean :active

      t.timestamps
    end
  end
end

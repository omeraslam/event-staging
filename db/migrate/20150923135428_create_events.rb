class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.string :background_img
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
    add_index :events, [:user_id, :created_at]
  end
end

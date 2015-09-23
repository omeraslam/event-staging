class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :time
      t.string :location
      t.string :background_img

      t.timestamps
    end
  end
end

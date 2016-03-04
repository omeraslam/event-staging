class AddExternalImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :external_image, :string
  end
end

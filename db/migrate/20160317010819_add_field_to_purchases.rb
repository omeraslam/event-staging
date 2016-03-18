class AddFieldToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :line_item_id, :string
  end
end

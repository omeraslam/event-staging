class AddPurchaseIdtoLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :purchase_id, :string
  end
end

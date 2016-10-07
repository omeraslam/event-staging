class AddColumnsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :order_total, :float
    add_column :purchases, :affiliate_code, :string
  end
end

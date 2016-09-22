class AddFeeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :total_fee, :float
    remove_column :purchases, :order_total, :float
    add_column :purchases, :total_order, :float
  end
end

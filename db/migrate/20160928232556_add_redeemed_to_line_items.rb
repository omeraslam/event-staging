class AddRedeemedToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :redeemed, :boolean, :default => false
  end
end

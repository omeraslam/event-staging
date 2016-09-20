class AddActiveToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :is_active, :boolean, default: false
    add_column :coupons, :is_fixed, :boolean, default: false
  end
end

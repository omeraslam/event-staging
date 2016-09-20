class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :promo_code
      t.float :discount
      t.string :coupon_type
      t.references :event, index: true

      t.timestamps
    end
  end
end

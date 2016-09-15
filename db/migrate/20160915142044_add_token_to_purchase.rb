class AddTokenToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :confirm_token, :string
  end
end

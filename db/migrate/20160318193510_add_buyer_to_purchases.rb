class AddBuyerToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :first_name, :string
    add_column :purchases, :last_name, :string
    add_column :purchases, :email, :string
    add_column :purchases, :phone_number, :string
    add_column :purchases, :stripe_id, :string
  end
end

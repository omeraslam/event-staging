class RemoveSubscriptiontypeToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :subscription_type, :string
  end
end

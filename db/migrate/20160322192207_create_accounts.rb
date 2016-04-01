class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|

      t.string :access_token
      t.string :refresh_token
      t.string :stripe_user_id
      t.string :stripe_publishable_key
      t.references :user, index: true, foreign_key: true

      t.timestamps

    end

    add_index :accounts, [:user_id, :created_at]
  end
end

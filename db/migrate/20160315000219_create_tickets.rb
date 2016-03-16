class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.integer :ticket_limit
      t.integer :buy_limit
      t.datetime :stop_date
      t.references :event, index: true, foreign_key: true

      t.timestamps
    end
    add_index :tickets, [:event_id, :created_at]
  end
end

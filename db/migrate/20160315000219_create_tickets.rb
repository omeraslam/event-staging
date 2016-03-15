class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.integer :ticket_limit
      t.integer :buy_limit
      t.datetime :stop_date

      t.timestamps
    end
  end
end

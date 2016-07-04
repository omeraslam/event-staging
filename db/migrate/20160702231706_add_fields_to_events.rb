class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :html_hero_1, :string
    add_column :events, :html_hero_button, :string
    add_column :events, :html_body_1, :string
    add_column :events, :html_footer_1, :string
    add_column :events, :html_footer_button, :string
  end
end

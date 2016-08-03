class ChangeTextFormatInEvents < ActiveRecord::Migration
  def up
    change_column :events, :html_hero_1, :text
    change_column :events, :html_hero_button, :text
    change_column :events, :html_body_1, :text
    change_column :events, :html_footer_1, :text
    change_column :events, :html_footer_button, :text
  end
  def down
    change_column :events, :html_hero_1, :string
    change_column :events, :html_hero_button, :string
    change_column :events, :html_body_1, :string
    change_column :events, :html_footer_1, :string
    change_column :events, :html_footer_button, :string
  end
end

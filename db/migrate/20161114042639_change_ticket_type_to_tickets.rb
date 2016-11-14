class ChangeTicketTypeToTickets < ActiveRecord::Migration
  def change

    change_column :survey_questions, :ticket_id, :string
  end
end

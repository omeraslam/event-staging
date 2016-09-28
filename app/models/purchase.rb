class Purchase < ActiveRecord::Base

    belongs_to :event
    has_many :line_items, dependent: :destroy
    before_create :generate_token, unless: :confirm_token?


    include ActionView::Helpers::NumberHelper
    



    def self.to_csv
        attributes = %w{first_name last_name email guest_count ticket_type purchase_total affiliate_code registration_date}

        CSV.generate(headers:true) do |csv|
            csv << attributes
            all.each do |attendee|
                csv << attributes.map{ |attr| attendee.send(attr) }
            end
        end
    end

private
    def guest_count

        
        @guest = LineItem.where(:purchase_id => id.to_s).first 

        "#{@guest.quantity.nil? ? 0 : @guest.quantity - 1}"

    end 
    
    def ticket_type

        @guest = LineItem.where(:purchase_id => id.to_s).first 
        @ticket = Ticket.find_by_id( @guest.ticket_id.to_i)


        "#{number_with_precision(@ticket.nil? ? 'N/A' : '"'+@ticket.title+'"')}"
    end 
    
    def purchase_total
        @total_oder = !total_order.nil? ? total_order/100 : 0
        "$#{number_with_precision(@total_oder, :precision => 2)}"
    end 


    def registration_date
        "#{created_at.to_date.strftime('%B %d, %Y')}"
    end
    def generate_token
      self.confirm_token = SecureRandom.uuid
    end
end

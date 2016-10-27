class Array
  def to_csv(csv_filename="hash.csv")
    require 'csv'

    attributes = %w{first_name last_name email ticket_type registration_date}

    CSV.generate(headers:true) do |csv|
        csv << attributes
        self.each_with_index do |attendee, index|
            csv << attendee
        end
    end
        
    # attributes = %w{first_name last_name email attending}
    # CSV.open(csv_filename, "wb") do |csv|
    #   csv << attributes
    #   #csv << self.first.keys # adds the attributes name on the first line
    #   # self.each do |hash|
    #   #   csv << hash.values
    #   # end
    # end
  end
end


# class Attendee < ActiveRecord::Base
#     belongs_to :line_item
#     def self.to_csv
#         attributes = %w{first_name last_name email attending}

#         CSV.generate(headers:true) do |csv|
#             csv << attributes
#             all.each do |attendee|
#                 csv << attendee.attributes.values_at(*attributes)
#             end
#         end
#     end
# end

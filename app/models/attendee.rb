class Attendee < ActiveRecord::Base
    belongs_to :line_item
	def self.to_csv
		attributes = %w{first_name last_name email attending}

		CSV.generate(headers:true) do |csv|
			csv << attributes
			all.each do |attendee|
				csv << attendee.attributes.values_at(*attributes)
			end
		end
	end
end

class Purchase < ActiveRecord::Base
    belongs_to :event
    has_many :line_items, dependent: :destroy
end

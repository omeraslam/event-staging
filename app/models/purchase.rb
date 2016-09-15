class Purchase < ActiveRecord::Base
    belongs_to :event
    has_many :line_items, dependent: :destroy
    before_create :generate_token, unless: :confirm_token?

private
    def generate_token
      self.confirm_token = SecureRandom.uuid
    end
end

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
    test "should not save event without name" do
        event = Event.new
        assert_not event.save,  "Saved the event without a title"
        # assert true
    end
end

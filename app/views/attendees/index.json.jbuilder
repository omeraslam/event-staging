json.array!(@attendees) do |attendee|
  json.extract! attendee, :id, :first_name, :last_name, :email, :phone_number, :message, :attending
  json.url attendee_url(attendee, format: :json)
end

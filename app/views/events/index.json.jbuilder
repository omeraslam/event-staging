json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :time, :location, :background_img
  json.url event_url(event, format: :json)
end

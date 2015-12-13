json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :location, :background_img, :user_id
  #json.url event_url(event, format: :json)
end

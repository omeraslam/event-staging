json.array!(@buyers) do |buyer|
  json.extract! buyer, :id, :first_name, :last_name, :email
  json.url buyer_url(buyer, format: :json)
end

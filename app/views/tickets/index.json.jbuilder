json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :title, :description, :price, :ticket_limit, :buy_limit, :stop_date
  json.url ticket_url(ticket, format: :json)
end

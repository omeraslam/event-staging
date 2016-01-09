json.array!(@themes) do |theme|
  json.extract! theme, :id, :name, :slug, :active
  json.url theme_url(theme, format: :json)
end

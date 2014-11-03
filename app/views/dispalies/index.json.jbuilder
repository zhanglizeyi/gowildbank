json.array!(@dispalies) do |dispaly|
  json.extract! dispaly, :id, :username, :password, :remember, :date, :dateofbirth
  json.url dispaly_url(dispaly, format: :json)
end

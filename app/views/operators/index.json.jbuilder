json.array!(@operators) do |operator|
  json.extract! operator, :id, :username, :label, :amount, :transfer
  json.url operator_url(operator, format: :json)
end

json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :From_account, :To_Account, :Amount
  json.url transfer_url(transfer, format: :json)
end

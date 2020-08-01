json.extract! business, :id, :name, :avg_rating, :created_at, :updated_at
json.address_attributes do
  json.partial! 'addresses/address', address: business.address
end
json.work_types do
  json.array! business.work_types.pluck(:name)
end

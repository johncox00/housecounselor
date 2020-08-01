json.extract! business_hour, :id, :open, :close, :business_id, :created_at, :updated_at
json.day WEEKDAYS[business_hour.day]

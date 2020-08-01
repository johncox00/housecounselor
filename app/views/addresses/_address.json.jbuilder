if address
  json.extract! address, :id, :line1, :line2
  if address.city_id.present?
    json.city address.city.name
  else
    json.city json.null!
  end
  if address.state_id.present?
    json.state address.state.abbr
  else
    json.state json.null!
  end
  if address.postal_code_id.present?
    json.postal_code address.postal_code.code
  else
    json.postal_code json.null!
  end
end

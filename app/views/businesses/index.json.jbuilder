json.total_pages @businesses.total_pages
json.total_count @businesses.total_count
json.current_page @page

json.results do
  json.array! @businesses, partial: "businesses/business", as: :business
end

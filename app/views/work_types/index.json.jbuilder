json.total_pages @work_types.total_pages
json.total_count @work_types.total_count
json.current_page @page

json.results do
  json.array! @work_types, partial: "work_types/work_type", as: :work_type
end

json.total_pages @reviews.total_pages
json.total_count @reviews.total_count
json.current_page @page

json.results do
  json.array! @reviews, partial: "reviews/review", as: :review
end

json.array!(@books) do |book|
  json.extract! book, :id, :isbn, :name, :cover
  json.url book_url(book, format: :json)
end

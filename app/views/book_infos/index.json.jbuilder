json.array!(@book_infos) do |book_info|
  json.extract! book_info, :id, :isbn, :name, :cover
  json.url book_info_url(book_info, format: :json)
end

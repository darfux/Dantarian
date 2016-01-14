json.array!(@users) do |user|
  json.extract! user, :id, :account, :name, :nickname, :password_digest
  json.url user_url(user, format: :json)
end

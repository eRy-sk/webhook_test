json.extract! user, :id, :name, :aid, :created_at, :updated_at
json.url user_url(user, format: :json)

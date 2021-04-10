defmodule TweetAPI do
  use HTTPoison.Base

  def process_request_url(url) do
    "http://localhost:4000/api" <> url
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_request_headers(headers) do
    headers ++ [{"Content-type", "application/vnd.api+json"}]
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end
end

# Create the user
user_data = %{data: %{attributes: %{email: "a@localhost"}}}
user_id = TweetAPI.post!("/users", user_data).body["data"]["id"]

# Create a tweet
tweet_data = %{data: %{attributes: %{body: "body", public: false}, relationships: %{user: %{data: %{id: user_id, type: "user"}}}, type: "tweet"}}
tweet = TweetAPI.post!("/tweets", tweet_data).body

# Delete the user
TweetAPI.delete!("/users/" <> user_id).body

# The tweet should also be deleted
404 = TweetAPI.get!("/tweets/" <> tweet["data"]["id"]).status_code

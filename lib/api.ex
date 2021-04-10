defmodule MyApp.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api
    ]

  resources do
    resource MyApp.User
    resource MyApp.Tweet
  end
end

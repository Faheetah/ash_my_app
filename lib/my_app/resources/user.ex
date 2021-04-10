defmodule MyApp.User do
  use Ash.Resource, data_layer: AshPostgres.DataLayer,
    extensions: [
      AshJsonApi.Resource
    ]

  json_api do
    type "user"

    routes do
      base "/users"

      get :read
      index  :read
      post :create
      patch :update
      delete :destroy
    end
  end

  postgres do
    table "tweets"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :string,
      allow_nil?: false,
      constraints: [
        match: ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
      ]
  end

  actions do
    create :create
    read :read
    update :update
    destroy :destroy
  end

  relationships do
    has_many :tweets, MyApp.Tweet, destination_field: :user_id
  end
end

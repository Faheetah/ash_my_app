defmodule MyApp.Tweet do
  use Ash.Resource, data_layer: AshPostgres.DataLayer,
    extensions: [
      AshJsonApi.Resource
    ]

  json_api do
    type "tweet"

    routes do
      base "/tweets"

      get :read
      index :read
      post :create
      patch :update
      delete :destroy
    end
  end

  postgres do
    table "users"
    repo MyApp.Repo
  end


  attributes do
    uuid_primary_key :id

    attribute :body, :string do
      allow_nil? false
      constraints max_length: 255
    end

    attribute :public, :boolean, allow_nil?: false, default: false

    create_timestamp :inserted_at

    update_timestamp :updated_at

  end

  actions do
    create :create do
      argument :user, :map, allow_nil?: false #arguments are sent with attributes in json:api
      # change is like `plug` but for resource actions
      # `manage_relationship` is documented in `Ash.Changeset` and supports *tons* of options
      # you can read more about both in the docs
      change manage_relationship(:user, type: :replace)
    end

    read :read
    update :update
    destroy :destroy
  end

  relationships do
    belongs_to :user, MyApp.User
  end
end

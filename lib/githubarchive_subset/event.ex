defmodule GithubarchiveSubset.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "events" do
    field :type, :string
    field :public, :boolean
    field :payload, :map
    field :repo, :map
    field :actor, :map
    field :org, :map
    field :created_at, :utc_datetime
    field :id, :string
    field :other, :map

    timestamps
  end

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, [:type, :payload, :actor, :repo, :created_at, :id, :public, :org, :other])
    |> validate_required([:type, :payload, :actor, :created_at, :id, :org])
  end
end

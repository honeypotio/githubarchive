defmodule GithubarchiveSubset.Repo.Migrations.AddEvents do
  use Ecto.Migration

  def change do
    # https://github.com/igrigorik/githubarchive.org/blob/master/bigquery/schema.js
    create table(:events, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :type, :string
      add :public, :boolean
      add :payload, :jsonb
      add :repo, :map
      add :actor, :map
      add :org, :map
      add :created_at, :utc_datetime
      add :id, :string
      add :other, :jsonb

      timestamps
    end
  end
end

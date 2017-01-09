use Mix.Config

config :githubarchive_subset, GithubarchiveSubset.Repo,[
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "githubarchive_subset_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
]

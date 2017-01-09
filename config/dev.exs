use Mix.Config

config :githubarchive_subset, GithubarchiveSubset.Repo,[
  adapter: Ecto.Adapters.Postgres,
  database: "githubarchive_subset_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
]

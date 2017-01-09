defmodule GithubarchiveSubset.Mixfile do
  use Mix.Project

  def project do
    [app: :githubarchive_subset,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
     ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto, :postgrex],
     mod: {GithubarchiveSubset, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 3.0"}, #required by ecto
      {:exjsx, "~> 3.2"},
      {:json, "~> 1.0"},
      {:jiffy, "~> 0.14.11"},
      {:jsone, "~> 1.4"},
      {:exvcr, "~> 0.8", only: :test}
    ]
  end
end

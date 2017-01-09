defmodule GithubarchiveSubset do
  def filter(event) do
    case event do
      %{"type" => "PullRequestEvent", "payload" => %{"action" => "opened"}} -> true
      _ -> false
    end
  end

  def write(body) do
    File.write("one_event.json", body, [:binary])
  end
end
Application.ensure_all_started :inets
require Poison

{:ok, {{_, 200, 'OK'}, _headers, body}} = :httpc.request(:get, {'http://data.githubarchive.org/2015-01-01-12.json.gz', []}, [], [body_format: :binary])

:zlib.gunzip(body)
|> Poison.decode!
|> Enum.filter(GithubarchiveSubset.filter/1)
|> Enum.take(1)
|> :jsx.encode!
|> GithubarchiveSubset.write

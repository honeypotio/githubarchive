defmodule GithubarchiveSubsetTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc
  alias GithubarchiveSubset.{Repo, Event}

  doctest GithubarchiveSubset

  @valid_attributes %{type: "PullRequestEvent", public: true, payload: %{}, repo: %{}, actor: %{}, org: %{}, created_at: DateTime.utc_now, id: "9sid"}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "it is posible to insert an event" do
    initial_count = Repo.aggregate(Event, :count, :uuid)
    Event.changeset(%Event{}, @valid_attributes) |> Repo.insert

    assert Repo.aggregate(Event, :count, :uuid) == (initial_count + 1)
  end

  test "download event data" do
    archive_link = 'http://data.githubarchive.org/2015-01-01-12.json.gz'
    use_cassette "github_archive_2015010112" do
      {:ok, {{_, 200, 'OK'}, _headers, archive}} = :httpc.request(
        :get,
        {archive_link, []},
        [],
        [body_format: :binary]
      )

      {:ok, unzipped} = :zlib.gunzip(archive)
      {:ok, results} = :jsx.decode(unzipped)

      assert length(results) == 1
    end
  end
end

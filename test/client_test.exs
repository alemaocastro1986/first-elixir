defmodule Exgit.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  describe "get_respos_by_username/1" do
    test "when the user has repos, return the repos" do
      username = "alemaocastro1986"

      response = [
        %{"id" => 1, "name" => "my repo 1"},
        %{"id" => 2, "name" => "my repo 2"}
      ]

      expected_response = {:ok, response}

      mock(fn
        %{method: :get, url: "https://api.github.com/users/alemaocastro1986/repos"} ->
          %Tesla.Env{status: 200, body: response}
      end)

      assert Exgit.Client.get_respos_by_username(username) == expected_response
    end

    test "when the user was NOT FOUND, return an error" do
      username = "alemaocastro198"

      expected_response = {:error, "User not found"}

      mock(fn
        %{method: :get, url: "https://api.github.com/users/alemaocastro198/repos"} ->
          %Tesla.Env{status: 404}
      end)

      assert Exgit.Client.get_respos_by_username(username) == expected_response
    end
  end
end

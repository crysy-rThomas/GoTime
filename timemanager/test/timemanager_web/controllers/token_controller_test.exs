defmodule TimemanagerWeb.TokenControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.TokensFixtures

  alias Timemanager.Tokens.Token

  @create_attrs %{
    token: "some token"
  }
  @update_attrs %{
    token: "some updated token"
  }
  @invalid_attrs %{token: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tokens", %{conn: conn} do
      conn = get(conn, ~p"/api/tokens")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create token" do
    test "renders token when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tokens", token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tokens/#{id}")

      assert %{
               "id" => ^id,
               "token" => "some token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tokens", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update token" do
    setup [:create_token]

    test "renders token when data is valid", %{conn: conn, token: %Token{id: id} = token} do
      conn = put(conn, ~p"/api/tokens/#{token}", token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tokens/#{id}")

      assert %{
               "id" => ^id,
               "token" => "some updated token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, token: token} do
      conn = put(conn, ~p"/api/tokens/#{token}", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete token" do
    setup [:create_token]

    test "deletes chosen token", %{conn: conn, token: token} do
      conn = delete(conn, ~p"/api/tokens/#{token}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tokens/#{token}")
      end
    end
  end

  defp create_token(_) do
    token = token_fixture()
    %{token: token}
  end
end

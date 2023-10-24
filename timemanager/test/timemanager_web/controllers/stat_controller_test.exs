defmodule TimemanagerWeb.StatControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.StatusFixtures

  alias Timemanager.Status.Stat

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all status", %{conn: conn} do
      conn = get(conn, ~p"/api/status")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create stat" do
    test "renders stat when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/status", stat: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/status/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/status", stat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stat" do
    setup [:create_stat]

    test "renders stat when data is valid", %{conn: conn, stat: %Stat{id: id} = stat} do
      conn = put(conn, ~p"/api/status/#{stat}", stat: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/status/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, stat: stat} do
      conn = put(conn, ~p"/api/status/#{stat}", stat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stat" do
    setup [:create_stat]

    test "deletes chosen stat", %{conn: conn, stat: stat} do
      conn = delete(conn, ~p"/api/status/#{stat}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/status/#{stat}")
      end
    end
  end

  defp create_stat(_) do
    stat = stat_fixture()
    %{stat: stat}
  end
end

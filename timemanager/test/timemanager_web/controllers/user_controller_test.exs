defmodule TimemanagerWeb.UserControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.UsersFixtures

  alias Timemanager.Users.User

  @create_attrs %{
<<<<<<< HEAD
    first_name: "some first_name",
    last_name: "some last_name"
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name"
  }
  @invalid_attrs %{first_name: nil, last_name: nil}
=======
    password: "some password",
    firstname: "some firstname",
    lastname: "some lastname",
    email: "some email"
  }
  @update_attrs %{
    password: "some updated password",
    firstname: "some updated firstname",
    lastname: "some updated lastname",
    email: "some updated email"
  }
  @invalid_attrs %{password: nil, firstname: nil, lastname: nil, email: nil}
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
<<<<<<< HEAD
               "first_name" => "some first_name",
               "last_name" => "some last_name"
=======
               "email" => "some email",
               "firstname" => "some firstname",
               "lastname" => "some lastname",
               "password" => "some password"
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
<<<<<<< HEAD
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
=======
               "email" => "some updated email",
               "firstname" => "some updated firstname",
               "lastname" => "some updated lastname",
               "password" => "some updated password"
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
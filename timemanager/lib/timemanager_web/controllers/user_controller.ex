defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Users
  alias Timemanager.Users.User

  action_fallback(TimemanagerWeb.FallbackController)

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Users.get_user(id) do
      {:ok, %User{}} ->
        user = Users.get_user(id)

        case Users.update_user(user, user_params) do
          {:ok, %User{} = user} ->
            render(conn, :show, user: user)

          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Could not update user with id #{id}")
        end

      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  def delete(conn, %{"id" => id}) do
    IO.puts("------UserStart-----")
    case Users.get_user!(id) do
      {:ok, %User{}} ->
        IO.puts("------User-----")
        user = Users.get_user!(id)

        case Users.delete_user(user.user) do
          {:ok, %User{}} ->
            render(:no_content, "")

          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Could not delete user with id #{id}")
        end

      {:error, _reason} ->
        IO.puts("------UserError-----")
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
    IO.puts("------UserEnd-----")
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(TimemanagerWeb.Endpoint, "user auth", user.id)

        conn
        |> put_status(:ok)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:login, token: token)

      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Invalid email or password")
    end
  end
end

defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Users
  alias Timemanager.Users.User
  alias Timemanager.Tokens
  alias Timemanager.Tokens.Token

  action_fallback(TimemanagerWeb.FallbackController)

  def index(conn, _params) do
    IO.inspect("---------tokenHeader Start---------")
    tokenHeader = Tokens.from_request(conn)
    IO.inspect("---------tokenHeader---------")
    case tokenHeader do
      nil ->
        IO.inspect("---------tokenHeade rnil---------")
        conn
        |> put_status(:ok)
        |> render(:error, error: "No token provided")
      _ ->
        IO.inspect("---------tokenHeader not nil---------")
        token = Tokens.get_token_from_token(tokenHeader)
        IO.inspect(token)
        case token do
          {:ok, token} ->
            user = Users.get_user(token.user)
            case user do
              {:ok, user} ->
                users = Users.list_users()
                render(conn, :index, users: users)
              {:error, _reason} ->
                conn
                |> put_status(:ok)
                |> render(:error, error: "Could not find user with id #{token.user}")
            end
          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Invalid token")
        end
    end
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
    user = Users.get_user(id)
    case user do
      {:ok, res} ->
        render(conn, :show, user: res)
      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user(id)
    case user do
      {:ok, res} ->

        case Users.update_user(res, user_params) do
          {:ok, res2} ->
            render(conn, :show, user: res2)

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
    user = Users.get_user(id)
    case user do
      {:ok, res} ->

        case Users.delete_user(res) do
          {:ok, res2} ->
            conn
            |> put_status(:ok)
            |> render(:showId, id: res2.id)

          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Could not delete user with id #{id}")
        end

      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(TimemanagerWeb.Endpoint, "user auth", user.id)
        Tokens.create_token(%{token: token, user: user.id})

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

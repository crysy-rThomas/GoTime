defmodule TimemanagerWeb.LoginController do
  use TimemanagerWeb, :controller

  alias Timemanager.Users
  alias Timemanager.Tokens

  def login(conn, %{"email" => email, "password" => password}) do
      case Users.authenticate_user(email, password) do
        {:ok, user} ->
          claim = %{"user_id" => user.id, "role" => user.role, "email" => user.email, "firstname" => user.firstname, "lastname" => user.lastname, "age" => DateTime.utc_now()}
          token = Phoenix.Token.sign(TimemanagerWeb.Endpoint, "user auth", claim)
          # Tokens.create_token(%{token: token, user: user.id})



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

defmodule Timemanager.Tokens do
  @moduledoc """
  The Tokens context.
  """
  import Plug.Conn
  alias Timemanager.Tokens

  alias Timemanager.Tokens.Token
  alias Timemanager.Users


  def init(_arg) do
  end

  def call(conn, _opts) do
    check_token(conn)
  end

  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  def from_request(conn) do
    case Tokens.get_req_header(conn, "authorization") do
      nil -> nil
      "Bearer " <> token -> token
      _ -> nil
    end
  end

  def get_req_header(conn, key) do
    key = String.downcase(key)
    case Enum.find(conn.req_headers, fn {k, _} -> String.downcase(k) == key end) do
      nil -> nil
      {_k, v} -> v
    end
  end


  def check_token(conn) do
    tokenHeader = from_request(conn)
    case tokenHeader do
      nil ->
        unauth(conn,"No Token provided")
      _ ->
        decoded_token = Phoenix.Token.verify(TimemanagerWeb.Endpoint, "user auth", tokenHeader)
        case decoded_token do
          {:ok, decoded_token} ->
            check_token_age(decoded_token, conn)
            user = Users.get_user(newToken["user_id"])
            case user do
              {:ok, user}
              ->
                conn
              {:error, _reason} ->
                unauth(conn,"User not found with id #{decoded_token["user_id"]}")
            end
          {:error, _reason} ->
            unauth(conn,"Token invalid")
        end
    end
  end

  defp unauth(conn,message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401,Jason.encode!(%{message: message}))
  end


  defp check_token_age(token, conn) do
    token_age = token["age"]
    case token_age do
      token_age ->
        age_in_minutes = DateTime.diff(DateTime.utc_now(), token_age, :minute)
        if (age_in_minutes > 240) do
            unauth(conn,"Token to old")
        else
            {:ok, token_age}
        end
      nil ->
        {:error, "Token invalid"}
    end

  end


end

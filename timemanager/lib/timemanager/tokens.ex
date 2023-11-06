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


  @doc """
  Returns the token in the header of conn
  """
  def from_request(conn) do
    case Tokens.get_req_header(conn, "authorization") do
      nil -> nil
      "Bearer " <> token -> token
      _ -> nil
    end
  end


  @doc """
  Returns the value of the given key in the request headers.
  """
  def get_req_header(conn, key) do
    key = String.downcase(key)
    case Enum.find(conn.req_headers, fn {k, _} -> String.downcase(k) == key end) do
      nil -> nil
      {_k, v} -> v
    end
  end

  @doc """
  Returns the token decoded in the header of conn
  """

  def get_decoded_token(conn) do
    tokenHeader = from_request(conn)
    case tokenHeader do
      nil ->
        unauth(conn,"No Token provided")
      _ ->
        decoded_token = Phoenix.Token.verify(TimemanagerWeb.Endpoint, "user auth", tokenHeader)
        case decoded_token do
          {:ok, decoded_token} ->
            check_token_age(decoded_token, conn)
            user = Users.get_user(decoded_token["user_id"])
            case user do
              {:ok, user}
              ->
                decoded_token
              {:error, _reason} ->
                unauth(conn,"User not found with id #{decoded_token["user_id"]}")
            end
          {:error, _reason} ->
            unauth(conn,"Token invalid")
        end
    end
  end


  @doc """
  check validity of token and age of token
  """

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
            user = Users.get_user(decoded_token["user_id"])
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
    if !token["phone"] do
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
    else
      {:ok, token}
    end
  end


end

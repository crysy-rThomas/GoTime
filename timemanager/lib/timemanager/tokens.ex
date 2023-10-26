defmodule Timemanager.Tokens do
  @moduledoc """
  The Tokens context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Tokens.Token
  alias Timemanager.Users

  def init(_arg) do
  end

  def call(conn, _opts) do
    check_token(conn)
  end


  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{data: %Token{}}

  """
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  def from_request(conn) do
    IO.inspect(get_req_header(conn, "authorization"))
    case get_req_header(conn, "authorization") do
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

  def get_token_from_token(token) do
    token = Repo.get_by(Token, token: token)
    if (token != nil) do
      {:ok, token}
    else
      {:error, "Token not found"}
    end
  end

  def check_token(conn) do
    tokenHeader = from_request(conn)
    case tokenHeader do
      nil ->
        {:error, "No token provided"}
      _ ->
        token = get_token_from_token(tokenHeader)
        case token do
          {:ok, token} ->
            user = Users.get_user(token.user)
            case user do
              {:ok, user} ->
                conn
              {:error, _reason} ->
                {:error, "User not found with id #{token.user}", conn}
              end
            {:error, _reason} ->
              {:error, "invalid token", conn}
        end
    end
  end
end

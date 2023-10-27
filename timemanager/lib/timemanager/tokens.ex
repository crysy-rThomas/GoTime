defmodule Timemanager.Tokens do
  @moduledoc """
  The Tokens context.
  """
  import Ecto.Query, warn: false
  import Plug.Conn
  alias Timemanager.Repo
  alias Timemanager.Tokens

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
    suppr_token_last(attrs.user)
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

  def get_token_from_token(token) do
    token = Repo.get_by(Token, token: token)
    if (token != nil) do
      {:ok, token}
    else
      {:error, "Token not found"}
    end
  end


  defp count_token(user_id) do
    from(t in Token, where: t.user == ^user_id)
    |> Repo.all()
    |> length()
  end

  defp suppr_token_last(user_id) do
    if (count_token(user_id) > 3) do
      oldest_token = from(t in Token, where: t.user == ^user_id, order_by: [asc: :inserted_at], limit: 1)
      |> Repo.one()
      Repo.delete(oldest_token)
    end
  end

  def check_token(conn) do
    tokenHeader = from_request(conn)
    case tokenHeader do
      nil ->
        unauth(conn,"No Token provided")
      _ ->
        token = get_token_from_token(tokenHeader)
        check_token_age(token, conn)
        case token do
          {:ok, token} ->
            user = Users.get_user(token.user)
            case user do
              {:ok, user}
              ->
                conn
              {:error, _reason} ->
                unauth(conn,"User not found with id #{token.user}")
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
    case token do
      {:ok, token} ->

        age_in_minutes = DateTime.diff(DateTime.utc_now(), token.inserted_at, :minute)

        if (age_in_minutes > 30) do
            suppr_token_last(token.user)
            unauth(conn,"Token to old")
        else
            {:ok, token}
        end
      {:error, _reason} ->
        {:error, "Token invalid"}
    end

  end


end

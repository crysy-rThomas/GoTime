defmodule Timemanager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Comeonin.Bcrypt
  alias Timemanager.Repo
  alias Timemanager.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id) do
    re = Repo.get(User, id)
    if (re != nil) do
      {:ok, re}
    else
      {:error, re}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do

    pass = attrs["password"]
    hash_pwd_salt(pass)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)
    if (user != nil) do
      if (user.password == password) do
        {:ok, user}
      else
        {:error, "Wrong password"}
      end
    else
      {:error, "User not found"}
    end
  end

    def hash_pwd_salt(password, opts \\ []) do
      Base.hash_password(
        password,
        BCrypt.gen_salt(
          Keyword.get(opts, :log_rounds, Application.get_env(:bcrypt_elixir, :log_rounds, 12)),
          Keyword.get(opts, :legacy, false)
        )
      )
    end
end

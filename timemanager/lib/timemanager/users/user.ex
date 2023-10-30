defmodule Timemanager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  schema "users" do
    field(:password, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:email, :string)
    field(:role, :id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :role])
    |> validate_required([:firstname, :lastname, :email, :password, :role])
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset
      password ->
          hash = Bcrypt.hash_pwd_salt(password,[log_rounds: 12])
          put_change(changeset, :password, hash)
    end |> (fn changeset ->
      changeset
    end).()
  end

end

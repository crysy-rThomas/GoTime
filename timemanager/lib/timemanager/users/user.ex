defmodule Timemanager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
<<<<<<< HEAD
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :password, :string
    field :role, :integer
=======
    field(:password, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:email, :string)
    field(:role, :id)
>>>>>>> 9ae9edd67f5264890d679dbe5c6ad4abec0e7ef6

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :role])
<<<<<<< HEAD
    |> validate_required([:firstname, :lastname , :email , :password])
=======
    |> validate_required([:firstname, :lastname, :email, :password, :role])
>>>>>>> 9ae9edd67f5264890d679dbe5c6ad4abec0e7ef6
  end
end

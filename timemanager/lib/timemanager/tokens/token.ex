defmodule Timemanager.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :token, :string
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user])
    |> validate_required([:token, :user])
  end
end

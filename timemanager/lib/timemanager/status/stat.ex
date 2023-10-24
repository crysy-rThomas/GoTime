defmodule Timemanager.Status.Stat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "status" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end

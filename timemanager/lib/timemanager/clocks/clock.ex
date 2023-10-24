defmodule Timemanager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    field :description, :string
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :description, :user])
<<<<<<< HEAD
    |> validate_required([:status, :time, :description , :user])
=======
    |> validate_required([:status, :time, :description, :user])
>>>>>>> 6a9259c2902d75acb3221326c7744480ecfff36f
  end
end

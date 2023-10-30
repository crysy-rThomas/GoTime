defmodule Timemanager.Workingtimes.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start_time, :end_time, :user])
    |> validate_required([:start_time, :end_time, :user])
  end
end

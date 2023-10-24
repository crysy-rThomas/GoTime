defmodule TimemanagerWeb.StatJSON do
  alias Timemanager.Status.Stat

  @doc """
  Renders a list of status.
  """
  def index(%{status: status}) do
    %{data: for(stat <- status, do: data(stat))}
  end

  @doc """
  Renders a single stat.
  """
  def show(%{stat: stat}) do
    %{data: data(stat)}
  end

  defp data(%Stat{} = stat) do
    %{
      id: stat.id,
      title: stat.title
    }
  end
end

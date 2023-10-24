defmodule Timemanager.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Workingtimes` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end_time: ~N[2023-10-23 09:17:00],
        start_time: ~N[2023-10-23 09:17:00]
      })
      |> Timemanager.Workingtimes.create_workingtime()

    workingtime
  end
end

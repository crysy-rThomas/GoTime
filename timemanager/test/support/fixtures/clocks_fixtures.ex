defmodule Timemanager.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: true,
        time: ~N[2023-10-23 09:17:00]
      })
      |> Timemanager.Clocks.create_clock()

    clock
  end
end

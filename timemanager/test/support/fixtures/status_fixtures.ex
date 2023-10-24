defmodule Timemanager.StatusFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Status` context.
  """

  @doc """
  Generate a stat.
  """
  def stat_fixture(attrs \\ %{}) do
    {:ok, stat} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Timemanager.Status.create_stat()

    stat
  end
end

defmodule Timemanager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        firstname: "some firstname",
        lastname: "some lastname",
        password: "some password",
        role: 1
      })
      |> Timemanager.Users.create_user()

    user
  end
end

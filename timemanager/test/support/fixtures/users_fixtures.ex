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
<<<<<<< HEAD
        first_name: "some first_name",
        last_name: "some last_name"
=======
        firstname: "some firstname",
        lastname: "some lastname"
      })
      |> Timemanager.Users.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        firstname: "some firstname",
        lastname: "some lastname",
        role: 42
      })
      |> Timemanager.Users.create_user()

    user
  end

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
        password: "some password"
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
      })
      |> Timemanager.Users.create_user()

    user
  end
end

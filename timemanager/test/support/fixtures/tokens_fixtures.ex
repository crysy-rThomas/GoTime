defmodule Timemanager.TokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Tokens` context.
  """

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        token: "some token"
      })
      |> Timemanager.Tokens.create_token()

    token
  end
end

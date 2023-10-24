defmodule TimemanagerWeb.UserJSON do
  alias Timemanager.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def login(%{token: token}) do
    %{data: %{token: token}}
  end

  def error(%{error: error}) do
    %{data: %{error: error}}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      password: user.password,
      role: user.role
    }
  end
end

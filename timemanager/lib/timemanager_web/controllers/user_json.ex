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

  defp data(%User{} = user) do
    %{
      id: user.id,
<<<<<<< HEAD
      first_name: user.first_name,
      last_name: user.last_name
=======
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      password: user.password
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
    }
  end
end

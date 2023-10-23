defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller
  alias Timemanager.Users
  alias Timemanager.Repo

  def index(conn, _params) do
    users = Repo.all(Users)

    render(conn, "index.json", users: users)
  end
end


defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 201, "Hello Jason")
  end
end

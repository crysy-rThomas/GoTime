defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.Clocks
  alias Timemanager.Clocks.Clock

  alias Timemanager.Users

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    client = Users.get_user(clock_params["user"])
    case client do
      {:ok, _} ->
        with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/clocks/#{clock}")
          |> render(:show, clock: clock)
        end
      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{clock_params["user"]}")
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def show_clocks_from_user_id(conn, %{"id" => id}) do
    client = Users.get_user(id)
    case client do
      {:ok, _} ->
        clocks = Clocks.get_clocks_from_user(id)
        conn
        |> put_status(:ok)
        |> render(:index, clocks: clocks)
      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end

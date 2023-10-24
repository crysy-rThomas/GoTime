defmodule TimemanagerWeb.StatController do
  use TimemanagerWeb, :controller

  alias Timemanager.Status
  alias Timemanager.Status.Stat

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    status = Status.list_status()
    render(conn, :index, status: status)
  end

  def create(conn, %{"stat" => stat_params}) do
    with {:ok, %Stat{} = stat} <- Status.create_stat(stat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/status/#{stat}")
      |> render(:show, stat: stat)
    end
  end

  def show(conn, %{"id" => id}) do
    stat = Status.get_stat!(id)
    render(conn, :show, stat: stat)
  end

  def update(conn, %{"id" => id, "stat" => stat_params}) do
    stat = Status.get_stat!(id)

    with {:ok, %Stat{} = stat} <- Status.update_stat(stat, stat_params) do
      render(conn, :show, stat: stat)
    end
  end

  def delete(conn, %{"id" => id}) do
    stat = Status.get_stat!(id)

    with {:ok, %Stat{}} <- Status.delete_stat(stat) do
      send_resp(conn, :no_content, "")
    end
  end
end

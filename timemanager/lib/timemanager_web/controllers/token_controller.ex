defmodule TimemanagerWeb.TokenController do
  use TimemanagerWeb, :controller

  alias Timemanager.Tokens
  alias Timemanager.Tokens.Token

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    
    tokens = Tokens.list_tokens()
    render(conn, :index, tokens: tokens)
  end

  def create(conn, %{"token" => token_params}) do
    with {:ok, %Token{} = token} <- Tokens.create_token(token_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tokens/#{token}")
      |> render(:show, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    token = Tokens.get_token!(id)
    render(conn, :show, token: token)
  end

  def update(conn, %{"id" => id, "token" => token_params}) do
    token = Tokens.get_token!(id)

    with {:ok, %Token{} = token} <- Tokens.update_token(token, token_params) do
      render(conn, :show, token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = Tokens.get_token!(id)

    with {:ok, %Token{}} <- Tokens.delete_token(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
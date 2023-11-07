defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Users
  alias Timemanager.Users.User

  # plug(Timemanager.Permissions, :check_permissions)




  action_fallback(TimemanagerWeb.FallbackController)
    @doc """
    List all users.
    """
    def index(conn, _params) do
      users = Users.list_users()
      render(conn, :index, users: users)
    end

    @doc """
    Create a new user.
    """
  def create(conn, %{"user" => user_params}) do
        check_email_is_used = Users.get_user_by_email(user_params["email"])
        case check_email_is_used do
          nil ->
            with {:ok, %User{} = user} <- Users.create_user(user_params) do
              conn
              |> put_status(:created)
              |> put_resp_header("location", ~p"/api/users/#{user}")
              |> render(:show, user: user)
            end
          _ ->
          conn
          |> put_status(:ok)
          |> render(:error, error: "Email is already used")
        end

  end


  # @doc """
  # return the current user information
  # """
  # def me(conn,_params) do
  #   decoded_token = Timemanager.Tokens.get_decoded_token(conn)
  #   id = decoded_token["user_id"]
  #   user = Users.get_user(id)
  #   case user do
  #     {:ok, res} ->
  #       user

  #     {:error, _reason} ->
  #       conn
  #       |> put_status(:ok)
  #       |> render(:error, error: "Could not find user with id #{id}")
  #   end
  # end




  @doc """
  Show a specific user.
  """
  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)
    case user do
      {:ok, res} ->
        render(conn, :show, user: res)
      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  @doc """
  Update a specific user.
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user(id)
    case user do
      {:ok, res} ->

        case Users.update_user(res, user_params) do
          {:ok, res2} ->
            render(conn, :show, user: res2)

          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Could not update user with id #{id}")
        end

      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end

  @doc """
  Delete a specific user.
  """
  def delete(conn, %{"id" => id}) do
    user = Users.get_user(id)
    case user do
      {:ok, res} ->

        case Users.delete_user(res) do
          {:ok, res2} ->
            conn
            |> put_status(:ok)
            |> render(:showId, id: res2.id)

          {:error, _reason} ->
            conn
            |> put_status(:ok)
            |> render(:error, error: "Could not delete user with id #{id}")
        end

      {:error, _reason} ->
        conn
        |> put_status(:ok)
        |> render(:error, error: "Could not find user with id #{id}")
    end
  end


end

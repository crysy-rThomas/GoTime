defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {HelloWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TimemanagerWeb do
    pipe_through(:api)
    resources("/users", UserController, except: [:new, :edit])
    resources("/tasks", TaskController, except: [:new, :edit])
    get("/tasks/users/:user_id", TaskController, :user_tasks)
  end
end

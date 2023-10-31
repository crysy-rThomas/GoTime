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
    plug Timemanager.Tokens, :check_token
  end

  pipeline :api_without_token do
    plug(:accepts, ["json"])
  end

  scope "/api", TimemanagerWeb do
    pipe_through(:api)

    resources("/roles", RoleController, except: [:new, :edit])
    resources("/users", UserController, except: [:new, :edit])
    resources("/clocks", ClockController, except: [:new, :edit, :index])
    get("/clocks/user/:id", ClockController, :show_clocks_from_user_id)
    resources("/working", WorkingtimeController, except: [:new, :edit])
    get("/working/user/:id", WorkingtimeController, :show_working_from_user_id)
    post("/login", UserController, :login)
  end

  scope "/", TimemanagerWeb do
    pipe_through(:api_without_token)
    post("/login", LoginController, :login)
    post("/register", UserController, :create)
  end


end

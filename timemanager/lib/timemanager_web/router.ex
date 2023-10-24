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
    resources("/roles", RoleController, except: [:new, :edit])
    resources("/users", UserController, except: [:new, :edit])
<<<<<<< HEAD
<<<<<<< HEAD
    resources("/roles", RoleController, except: [:new, :edit])
    resources("/clocks", ClockController)
=======
    resources("/clock", ClockController, except: [:new, :edit])
=======
    resources("/clock", ClockController, except: [:new, :edit, :index])
    get("/clock/user/:id", ClockController, :show_clocks_from_user_id)
>>>>>>> 6a9259c2902d75acb3221326c7744480ecfff36f
    resources("/working", WorkingtimeController, except: [:new, :edit])
    post("/login", UserController, :login)
>>>>>>> 9ae9edd67f5264890d679dbe5c6ad4abec0e7ef6
  end
end

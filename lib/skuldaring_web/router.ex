defmodule SkuldaringWeb.Router do
  use SkuldaringWeb, :router

  alias Skuldaring.Repo
  alias Skuldaring.Accounts.User

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SkuldaringWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :put_root_layout, {SkuldaringWeb.LayoutView, :admin}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SkuldaringWeb do
    pipe_through :browser

    get "/session/new", SessionController, :new
    get "/logout", SessionController, :logout

    live "/", FrontLive, :index
  end

  scope "/sekolah", SkuldaringWeb.School, as: :school do
    pipe_through :browser

    live "/", SchoolLive, :index
  end

  scope "/admin", SkuldaringWeb.Admin, as: :admin do
    pipe_through [:browser, :authorize_check, :admin]

    get "/", AdminController, :index

    resources "/schools", SchoolController
  end

  def authorize_check(conn, _opts) do
    case get_session(conn) do
      %{"user_id" => user_id} ->
        with user when not is_nil(user) <- Repo.get(User, user_id),
          1 <- user.id
        do
          conn
        else
          _ -> conn
            |> put_flash(:error, "Unauthorized")
            |> redirect(to: "/")
        end
      _ -> conn
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SkuldaringWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SkuldaringWeb.Telemetry
    end
  end
end

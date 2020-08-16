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

    live "/", FrontLive.Index, :index
    live "/beranda-sekolah/:id", SchoolLive.Show, :index
  end

  scope "/sekolah", SkuldaringWeb.SchoolLive do
    pipe_through [:browser, :authenticated_check]

    live "/", Index, :index
    live "/new", Index, :new

    live "/:id/edit", Edit, :index
    live "/:id/edit/room", Edit, :room_index
    live "/:id/edit/room/:room_id/edit", Edit, :room_edit
  end

  scope "/admin", SkuldaringWeb.Admin, as: :admin do
    pipe_through [:browser, :admin_check, :admin]

    get "/", AdminController, :index

    resources "/schools", SchoolController
  end

  def authenticated_check(conn, _opts) do
    with %{"user_id" => user_id} <- get_session(conn),
      user when not is_nil(user) <- Repo.get(User, user_id)
    do
      conn
    else
      _ -> conn
        |> delete_session(:user_id)
        |> put_session(:redirect_url, request_url(conn))
        |> put_flash(:error, "Silahkan masuk terlebih dahulu")
        |> redirect(to: "/")
    end
  end

  def admin_check(conn, _opts) do
    case get_session(conn) do
      %{"user_id" => user_id} ->
        with user when not is_nil(user) <- Repo.get(User, user_id),
          1 <- user.id
        do
          conn
        else
          _ -> conn
            |> put_flash(:error, "Akses terbatas")
            |> redirect(to: "/")
        end
      _ -> conn
        |> put_flash(:error, "Silahkan masuk terlebih dahulu")
        |> redirect(to: "/")
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

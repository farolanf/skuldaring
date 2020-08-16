defmodule SkuldaringWeb.NavLive.BreadcrumbsLive do
  use SkuldaringWeb, :live_component

  import Skuldaring.Utils

  @paths [
    # path patterns for breadcrumbs
    {"/", "Beranda"},
    {"/akun", "Akun"},
    {"/sekolah", "Sekolah"},
    {"/sekolah/*/edit", "Atur Sekolah"},
    {"/sekolah/*/edit/room", "Ruangan"},
    {"/sekolah/*/edit/room/*/edit", "Atur Ruangan"},
    {"/visit/*", "Beranda Sekolah"},
    {"/visit/*/room/*", "Ruangan"},
  ]

  @impl true
  def update(assigns, socket) do
    socket = case assigns do
      %{uri: %{path: path}} ->
        socket
        |> assign(:path, get_breadcrumbs(path, @paths))
      _ -> socket
    end

    {:ok, socket}
  end

 end

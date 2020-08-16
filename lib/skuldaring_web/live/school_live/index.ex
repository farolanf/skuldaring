defmodule SkuldaringWeb.SchoolLive.Index do
  use SkuldaringWeb, :live_view

  require Logger

  import Ecto.Query
  import SkuldaringWeb.Helpers
  import Skuldaring.Permissions

  alias Skuldaring.{Repo, Schools}
  alias Skuldaring.Schools.School

  @impl true
  def mount(_params, %{} = session, socket) do
    socket = socket
    |> handle_session(session)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, apply_action(socket.assigns.live_action, params, socket)}
  end

  defp apply_action(:index, _params, socket) do
    socket
    |> assign(:page_title, "Daftar Sekolah")
    |> assign(:school, nil)
  end

  defp apply_action(:new, _params, socket) do
    socket
    |> assign(:page_title, "Sekolah Baru")
    |> assign(:school, %School{})
  end

  @impl true
  def handle_event(event, params, socket) do
    {:noreply, apply_event(event, params, socket)}
  end

  def apply_event("activate", %{"id" => id}, socket) do
    with %{user: user} <- socket.assigns,
      school <- Schools.get_school!(id),
      true <- allow?(user, school, "change"),
      {:ok, _school} <- Schools.update_school(school, %{active: true}, %{})
    do
      socket
        |> put_flash(:success, "Sukses mengaktifkan sekolah")
        |> push_redirect(to: Routes.school_index_path(socket, :index))
    else
      _ -> socket
        |> put_flash(:error, "Gagal mengaktifkan sekolah")
    end
  end

  def apply_event("deactivate", %{"id" => id}, socket) do
    with %{user: user} <- socket.assigns,
      school <- Schools.get_school!(id),
      true <- allow?(user, school, "change"),
      {:ok, _school} <- Schools.update_school(school, %{active: false}, %{})
    do
      socket
        |> put_flash(:success, "Sukses menon-aktifkan sekolah")
        |> push_redirect(to: Routes.school_index_path(socket, :index))
    else
      _ -> socket
        |> put_flash(:error, "Gagal menon-aktifkan sekolah")
    end
  end

end

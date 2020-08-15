defmodule SkuldaringWeb.School.SchoolLive do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers
  import Skuldaring.Permissions

  alias Skuldaring.Schools
  alias Skuldaring.Schools.School

  @impl true
  def mount(_params, %{} = session, socket) do
    socket = socket
    |> handle_session(session)

    socket = case session do
      %{"user_id" => user_id} ->
        search_params = %{where: %{user_id: user_id}}
        socket
        |> assign(:schools, Schools.find_schools(search_params))
      _ -> socket
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
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

  defp apply_action(:edit, %{"id" => id}, socket) do
    socket
    |> assign(:page_title, "Ubah Sekolah")
    |> assign(:school, Schools.get_school!(id))
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
    else
      _ -> socket
        |> put_flash(:error, "Gagal menon-aktifkan sekolah")
    end
  end

end

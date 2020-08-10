defmodule SkuldaringWeb.SchoolForm do
  use SkuldaringWeb, :live_component

  alias Skuldaring.Schools
  alias Skuldaring.Permissions

  @impl true
  def mount(socket) do
    {:ok, assign(socket, touched: false)}
  end

  @impl true
  def update(%{school: school} = assigns, socket) do
    changeset = Schools.change_school(school)

    socket = socket
    |> assign(assigns)
    |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"school" => params}, socket) do
    changeset = socket.assigns.school
    |> Schools.change_school(params, %{user_id: socket.assigns.user.id})
    |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, touched: true)}
  end

  @impl true
  def handle_event("save", %{"school" => params}, socket) do
    socket = socket
    |> assign(touched: true)

    save_post(socket, socket.assigns.action, params)
  end

  defp save_post(socket, :new, params) do
    if !Permissions.allow?(socket.assigns.user, "school", "create") do
      handle_access_denied(socket)
    else
      case Schools.create_school(params, %{user_id: socket.assigns.user.id}) do
        {:ok, _school} ->
          socket = socket
          |> put_flash(:success, "Sukses membuat sekolah baru")
          |> push_redirect(to: socket.assigns.return_to)

          {:noreply, socket}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end
  end

  defp save_post(socket, :edit, params) do
    if !Permissions.allow?(socket.assigns.user, socket.assigns.school, "change") do
      handle_access_denied(socket)
    else
      changes = %{user_id: socket.assigns.user.id}
      case Schools.update_school(socket.assigns.school, params, changes) do
        {:ok, _school} ->
          socket = socket
          |> put_flash(:success, "Sukses mengubah sekolah")
          |> push_redirect(to: socket.assigns.return_to)

          {:noreply, socket}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end
  end

end

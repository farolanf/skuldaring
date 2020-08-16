defmodule SkuldaringWeb.SchoolLive.Room.Form do
  use SkuldaringWeb, :live_component

  import Skuldaring.Permissions

  alias Skuldaring.Schools

  @impl true
  def mount(socket) do
    {:ok, assign(socket, touched: false)}
  end

  @impl true
  def update(%{room: room} = assigns, socket) do
    changeset = Schools.change_room(room)

    socket = socket
    |> assign(assigns |> Map.delete(:flash))
    |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"room" => params}, socket) do
    %{user: user, room: room, school: school} = socket.assigns

    changes = %{
      school_id: school.id,
      user_id: user.id,
    }

    changeset = room
    |> Schools.change_room(params, changes)
    |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, touched: true)}
  end

  @impl true
  def handle_event("save", %{"room" => params}, socket) do
    socket = socket
    |> assign(touched: true)

    {:noreply, save(socket.assigns.action, params, socket)}
  end

  defp save(:new, params, socket) do
    %{user: user, school: school} = socket.assigns

    if !allow?(user, school, "change") || !allow?(user, "room", "create") do
      handle_access_denied(socket)
    else
      changes = %{
        school_id: school.id,
        user_id: user.id,
      }

      case Schools.create_room(params, changes) do
        {:ok, _room} ->
          socket
          |> put_flash(:success, "Sukses membuat ruangan baru")
          |> redirect(to: socket.assigns.return_to)
        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(changeset: changeset)
      end
    end
  end

  defp save(:edit, params, socket) do
    %{user: user, school: school, room: room} = socket.assigns

    if !allow?(user, school, "change") || !allow?(user, room, "change") do
      handle_access_denied(socket)
    else
      changes = %{
        school_id: school.id,
        user_id: user.id,
      }

      case Schools.update_school(school, params, changes) do
        {:ok, _school} ->
          socket
          |> put_flash(:success, "Sukses mengubah ruangan")
        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(changeset: changeset)
      end
    end
  end

end

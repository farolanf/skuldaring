defmodule SkuldaringWeb.SchoolForm do
  use SkuldaringWeb, :live_component

  alias Skuldaring.Schools

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
    |> Schools.change_school(params)
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
    case Schools.create_school(params) do
      {:ok, _school} ->
        socket = socket
        |> put_flash(:info, "School created successfully")
        |> push_redirect(to: socket.assigns.return_to)

        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_post(socket, :edit, params) do
    case Schools.update_school(socket.assigns.school, params) do
      {:ok, _school} ->
        socket = socket
        |> put_flash(:info, "School updated successfully")
        |> push_redirect(to: socket.assigns.return_to)

        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end

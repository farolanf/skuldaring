defmodule SkuldaringWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `SkuldaringWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, SkuldaringWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def live_modal(socket, id, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: id, return_to: path, component: component, opts: opts]
    live_component(socket, SkuldaringWeb.ModalComponent, modal_opts)
  end
end

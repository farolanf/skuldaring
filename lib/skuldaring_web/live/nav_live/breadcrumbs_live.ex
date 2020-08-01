defmodule SkuldaringWeb.NavLive.BreadcrumbsLive do
  use SkuldaringWeb, :live_component

  @impl true
  def preload(assign_list) do
    IO.inspect assign_list, label: "assigns"
    path = []

    # path = [%{label: "Beranda", to: "/"} | path]

    List.replace_at(
      assign_list,
      0,
      Map.merge(List.first(assign_list), %{path: path})
    )
  end
end

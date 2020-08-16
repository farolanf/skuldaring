defmodule SkuldaringWeb.NavLive.BreadcrumbsLive do
  use SkuldaringWeb, :live_component

  import Skuldaring.Utils

  @paths [
    # path regexes for breadcrumbs
    {"/", "Beranda"},
    {"/akun", "Akun"},
    {"/sekolah", "Sekolah"},
    {"/sekolah/[^/]+/edit", "Atur Sekolah"},
  ]

  @impl true
  def preload(assign_list) do
    breadcrumbs = case assign_list do
      [%{uri: %{path: path}}] -> get_breadcrumbs(path, @paths)
      _ -> []
    end

    List.replace_at(
      assign_list,
      0,
      Map.merge(
        List.first(assign_list),
        %{path: breadcrumbs}
      )
    )
  end

 end

defmodule Skuldaring.Utils do

  def get_breadcrumbs(url_path, paths) when is_binary(url_path) do
    paths = Enum.sort_by(
      paths,
      &(length(String.split(elem(&1, 0), "/")) * String.length(elem(&1, 0))),
      &>=/2
    )

    breadcrumbs = Enum.reduce(
      paths,
      [],
      fn {to, label}, breadcrumbs ->
        {:ok, re} = Regex.compile(to)
        case Regex.run(re, url_path) do
          [path | _matches] -> [{path, label} | breadcrumbs]
          _ -> breadcrumbs
        end
      end
    )

    breadcrumbs = if length(breadcrumbs) <= 1, do: [], else: breadcrumbs

    if length(breadcrumbs) > 0 do
      List.replace_at(breadcrumbs, -1, elem(List.last(breadcrumbs), 1))
    else
      breadcrumbs
    end
  end

end

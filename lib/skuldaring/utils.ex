defmodule Skuldaring.Utils do

  import Ecto.Query

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
        to = to |> String.replace("*", "[^/]+")
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

  def find_query(model, %{} = params) do
    query = from s in model

    query = case params do
      %{where: where} -> where(query, ^params_where(where))
      _ -> query
    end

    case params do
      %{order: order} ->
        order_by(query, ^params_order(order))
      _ -> query
    end
  end

  def params_where(%{} = params) do
    params
    |> Map.keys()
    |> Enum.reduce([], fn key, where ->
      value = IndifferentAccess.get(params, key)
      Keyword.put(where, key, value)
    end)
  end

  def params_order(params) do
    params
    |> Enum.reduce([], fn
      {field, sort}, order ->
        Keyword.put(order, ensure_atom(sort), field)
      field, order ->
        Keyword.put(order, :asc, ensure_atom(field))
    end)
    |> Enum.reverse
  end

  defp ensure_atom(arg) when is_atom(arg), do: arg
  defp ensure_atom(arg) when is_binary(arg), do: String.to_atom(arg)

end

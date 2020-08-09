defprotocol IndifferentAccess do
  def get(data, key)
end

defimpl IndifferentAccess, for: Map do

  def get(data, key) when is_binary(key) do
    case Map.fetch(data, key) do
      {:ok, value} -> value
      :error ->
        case Map.fetch(data, String.to_atom(key)) do
          {:ok, value} -> value
          :error -> :error
        end
    end
  end

  def get(data, key) when is_atom(key) do
    case Map.fetch(data, key) do
      {:ok, value} -> value
      :error ->
        case Map.fetch(data, Atom.to_string(key)) do
          {:ok, value} -> value
          :error -> :error
        end
    end
  end

end

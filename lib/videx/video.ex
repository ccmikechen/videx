defmodule Videx.Video do
  defmacro __using__(_opts) do
    quote do
      defstruct [:type, :id, :params]

      defp parse_params(nil), do: %{}
      defp parse_params(query), do: URI.decode_query(query)

      defp encode_query(params) when params == %{}, do: nil
      defp encode_query(params), do: URI.encode_query(params)

      defp merge_query(query, key, value, default) do
        cond do
          value && default ->
            Map.put(query, key, 1)

          !(value || default) ->
            Map.put(query, key, 0)

          true ->
            query
        end
      end
    end
  end
end

defmodule Videx.Youtube do
  defstruct [:type, :id, :params]

  # From https://stackoverflow.com/a/37704433
  @regex ~r/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/

  def match?(url), do: String.match?(url, @regex)

  def parse(url) do
    case URI.parse(url) do
      %URI{host: "youtu.be", path: "/" <> id, query: query} ->
        %__MODULE__{type: :short, id: id, params: parse_params(query)}

      %URI{path: "/embed/" <> id, query: query} ->
        %__MODULE__{type: :embed, id: id, params: parse_params(query)}

      %URI{path: "/v/" <> id, query: query} ->
        %__MODULE__{type: :video, id: id, params: parse_params(query)}

      %URI{path: "/oembed", query: query} ->
        query
        |> parse_params()
        |> Map.pop("url")
        |> case do
          {nil, _} ->
            nil

          {original_url, params} ->
            case parse(original_url) do
              nil -> nil
              %{id: id} -> %__MODULE__{type: :oembed, id: id, params: params}
            end
        end

      %URI{query: query} ->
        query
        |> parse_params()
        |> Map.pop("v")
        |> case do
          {nil, _} ->
            nil

          {id, params} ->
            %__MODULE__{type: :long, id: id, params: params}
        end
    end
  end

  defp parse_params(nil), do: %{}
  defp parse_params(query), do: URI.decode_query(query)
end

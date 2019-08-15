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

  def generate(_, _, params \\ %{})

  def generate(%__MODULE__{id: id}, :long, params) do
    query =
      %{v: id}
      |> Map.merge(params)
      |> encode_query()

    %URI{
      scheme: "https",
      host: "www.youtube.com",
      path: "/watch",
      query: query
    }
    |> URI.to_string()
  end

  def generate(%__MODULE__{id: id}, :short, params) do
    %URI{
      scheme: "https",
      host: "youtu.be",
      path: "/#{id}",
      query: encode_query(params)
    }
    |> URI.to_string()
  end

  def generate(%__MODULE__{id: id}, :embed, params) do
    %URI{
      scheme: "https",
      host: "www.youtube.com",
      path: "/embed/#{id}",
      query: encode_query(params)
    }
    |> URI.to_string()
  end

  def generate(%__MODULE__{} = video, :oembed, params) do
    query =
      %{url: generate(video, :long)}
      |> Map.merge(params)
      |> encode_query()

    %URI{
      scheme: "https",
      host: "www.youtube.com",
      path: "/oembed",
      query: query
    }
    |> URI.to_string()
  end

  def generate(%__MODULE__{id: id}, :video, params) do
    %URI{
      scheme: "https",
      host: "www.youtube.com",
      path: "/v/#{id}",
      query: encode_query(params)
    }
    |> URI.to_string()
  end

  def generate(id, type, params) when is_binary(id) do
    generate(%__MODULE__{id: id}, type, params)
  end

  defp parse_params(nil), do: %{}
  defp parse_params(query), do: URI.decode_query(query)

  defp encode_query(params) when params == %{}, do: nil
  defp encode_query(params), do: URI.encode_query(params)
end

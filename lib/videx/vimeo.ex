defmodule Videx.Vimeo do
  use Videx.Video

  @regex ~r/^((?:https?:)?\/\/)?(?:www\.|player\.)?vimeo.com\/(video\/|)(\d+)(?:[a-zA-Z0-9_\-]+)([\w\-]+)(\S+)?/

  @doc """
  Check if the URL is valid video URL for Vimeo.

  ## Examples

      iex> Videx.Vimeo.match?("https://vimeo.com/22439234")
      true

  """
  def match?(url), do: String.match?(url, @regex)

  @doc """
  Parse and extract information from Vimeo video URL.

  ## Examples

      iex> Videx.Vimeo.parse("https://vimeo.com/22439234")
      %Videx.Vimeo{id: "22439234", params: %{}, type: :short}

  """
  def parse(url) do
    case URI.parse(url) do
      %URI{host: "vimeo.com", path: "/" <> id, query: query} ->
        %__MODULE__{type: :short, id: id, params: parse_params(query)}

      %URI{host: "player.vimeo.com", path: "/video/" <> id, query: query} ->
        %__MODULE__{type: :embed, id: id, params: parse_params(query)}

      _ ->
        nil
    end
  end

  @doc """
  Generate URL for Vimeo video.

  ## Examples

      iex> Videx.Vimeo.generate(%Videx.Vimeo{id: "22439234"})
      "https://vimeo.com/22439234"

      iex> Videx.Vimeo.generate("22439234", :embed, %{title: 0})
      "https://player.vimeo.com/video/22439234?title=0"

  """
  def generate(_, type \\ :short, params \\ %{})

  def generate(%__MODULE__{id: id}, :short, params) do
    %URI{
      scheme: "https",
      host: "vimeo.com",
      path: "/#{id}",
      query: encode_query(params)
    }
    |> URI.to_string()
  end

  def generate(%__MODULE__{id: id}, :embed, params) do
    %URI{
      scheme: "https",
      host: "player.vimeo.com",
      path: "/video/#{id}",
      query: encode_query(params)
    }
    |> URI.to_string()
  end

  def generate(id, type, params) when is_binary(id) do
    generate(%__MODULE__{id: id}, type, params)
  end

  @doc """
  Generate embed HTML for Vimeo video.

  ## Examples

      iex> Videx.Vimeo.html(%Videx.Vimeo{id: "22439234"})
      "<iframe src=\\"https://player.vimeo.com/video/22439234\\" width=\\"640\\" height=\\"360\\" frameborder=\\"0\\" allow=\\"autoplay; fullscreen\\" allowfullscreen></iframe>"

      iex> Videx.Vimeo.html("22439234", width: 320, height: 240)
      "<iframe src=\\"https://player.vimeo.com/video/22439234\\" width=\\"320\\" height=\\"240\\" frameborder=\\"0\\" allow=\\"autoplay; fullscreen\\" allowfullscreen></iframe>"

  """
  def html(_, params \\ [])

  def html(%__MODULE__{id: id}, params) do
    width = params[:width] || 640
    height = params[:height] || 360
    color = params[:color]
    portrait = is_nil(params[:portrait]) || params[:portrait]
    title = is_nil(params[:title]) || params[:title]
    byline = is_nil(params[:byline]) || params[:byline]
    autoplay = params[:autoplay]
    loop = params[:loop]

    query =
      %{}
      |> Map.merge(
        if color do
          %{color: color}
        else
          %{}
        end
      )
      |> merge_query(:portrait, portrait, false)
      |> merge_query(:title, title, false)
      |> merge_query(:byline, byline, false)
      |> merge_query(:autoplay, autoplay, true)
      |> merge_query(:loop, loop, true)
      |> encode_query()

    url =
      %URI{
        scheme: "https",
        host: "player.vimeo.com",
        path: "/video/#{id}",
        query: query
      }
      |> URI.to_string()

    "<iframe src=\"#{url}\" width=\"#{width}\" height=\"#{height}\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen></iframe>"
  end

  def html(id, params) when is_binary(id) do
    html(%__MODULE__{id: id}, params)
  end
end

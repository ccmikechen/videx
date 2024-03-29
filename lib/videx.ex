defmodule Videx do
  @moduledoc """
  Documentation for Videx.
  """

  alias Videx.{Youtube, Vimeo}

  @doc """
  Parse video URL.

  ## Examples

      iex> Videx.parse("https://www.youtube.com/watch?v=Hh9yZWeTmVM")
      %Videx.Youtube{id: "Hh9yZWeTmVM", params: %{}, type: :long}

  """
  def parse(url) do
    cond do
      Youtube.match?(url) -> Youtube.parse(url)
      Vimeo.match?(url) -> Vimeo.parse(url)
      true -> nil
    end
  end
end

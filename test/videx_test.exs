defmodule VidexTest do
  use ExUnit.Case
  doctest Videx

  @youtube_long "https://www.youtube.com/watch?v=Hh9yZWeTmVM"
  @youtube_short "https://youtu.be/Hh9yZWeTmVM?t=80"
  @youtube_embed "https://www.youtube.com/embed/Hh9yZWeTmVM"
  @youtube_oembed "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=Hh9yZWeTmVM&format=json"
  @youtube_video "http://www.youtube.com/v/Hh9yZWeTmVM?version=3&autohide=1"

  @elixir_url "https://elixir-lang.org/"

  test "parse Youtube long URL" do
    parsed = Videx.parse(@youtube_long)
    assert parsed == %Videx.Youtube{type: :long, id: "Hh9yZWeTmVM", params: %{}}
  end

  test "parse Youtube short URL" do
    parsed = Videx.parse(@youtube_short)
    assert parsed == %Videx.Youtube{type: :short, id: "Hh9yZWeTmVM", params: %{"t" => "80"}}
  end

  test "parse Youtube embed URL" do
    parsed = Videx.parse(@youtube_embed)
    assert parsed == %Videx.Youtube{type: :embed, id: "Hh9yZWeTmVM", params: %{}}
  end

  test "parse Youtube oembed URL" do
    parsed = Videx.parse(@youtube_oembed)

    assert parsed == %Videx.Youtube{
             type: :oembed,
             id: "Hh9yZWeTmVM",
             params: %{"format" => "json"}
           }
  end

  test "parse Youtube video URL" do
    parsed = Videx.parse(@youtube_video)

    assert parsed == %Videx.Youtube{
             type: :video,
             id: "Hh9yZWeTmVM",
             params: %{"version" => "3", "autohide" => "1"}
           }
  end

  test "parse non-video URL" do
    parsed = Videx.parse(@elixir_url)
    assert parsed == nil
  end
end

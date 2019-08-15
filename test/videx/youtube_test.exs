defmodule Videx.YoutubeTest do
  use ExUnit.Case
  doctest Videx.Youtube

  alias Videx.Youtube

  @video %Youtube{id: "Hh9yZWeTmVM"}

  test "generate Youtube long URL" do
    url = Youtube.generate(@video, :long)
    assert url == "https://www.youtube.com/watch?v=Hh9yZWeTmVM"
  end

  test "generate Youtube long URL with params" do
    url = Youtube.generate(@video, :long, %{t: 80})
    assert url == "https://www.youtube.com/watch?t=80&v=Hh9yZWeTmVM"
  end

  test "generate Youtube short URL" do
    url = Youtube.generate(@video, :short)
    assert url == "https://youtu.be/Hh9yZWeTmVM"
  end

  test "generate Youtube short URL with params" do
    url = Youtube.generate(@video, :short, %{t: 80})
    assert url == "https://youtu.be/Hh9yZWeTmVM?t=80"
  end

  test "generate Youtube embed URL" do
    url = Youtube.generate(@video, :embed)
    assert url == "https://www.youtube.com/embed/Hh9yZWeTmVM"
  end

  test "generate Youtube embed URL with params" do
    url = Youtube.generate(@video, :embed, %{t: 80})
    assert url == "https://www.youtube.com/embed/Hh9yZWeTmVM?t=80"
  end

  test "generate Youtube oembed URL" do
    url = Youtube.generate(@video, :oembed)

    assert url ==
             "https://www.youtube.com/oembed?url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DHh9yZWeTmVM"
  end

  test "generate Youtube oembed URL with params" do
    url = Youtube.generate(@video, :oembed, %{format: :json})

    assert url ==
             "https://www.youtube.com/oembed?format=json&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DHh9yZWeTmVM"
  end

  test "generate Youtube video URL" do
    url = Youtube.generate(@video, :video)
    assert url == "https://www.youtube.com/v/Hh9yZWeTmVM"
  end

  test "generate Youtube video URL with params" do
    url = Youtube.generate(@video, :video, %{version: 3, autohide: 1})
    assert url == "https://www.youtube.com/v/Hh9yZWeTmVM?autohide=1&version=3"
  end
end

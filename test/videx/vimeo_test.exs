defmodule Videx.VimeoTest do
  use ExUnit.Case
  doctest Videx.Vimeo

  alias Videx.Vimeo

  @video %Vimeo{id: "22439234"}

  test "generate Vimeo short URL" do
    url = Vimeo.generate(@video, :short)
    assert url == "https://vimeo.com/22439234"
  end

  test "generate Vimeo embed URL" do
    url = Vimeo.generate(@video, :embed)
    assert url == "https://player.vimeo.com/video/22439234"
  end

  test "generate Vimeo embed URL with params" do
    url = Vimeo.generate(@video, :embed, %{title: 0, byline: 0})
    assert url == "https://player.vimeo.com/video/22439234?byline=0&title=0"
  end

  test "generate Vimeo embed HTML" do
    html = Vimeo.html(@video)

    assert html ==
             "<iframe src=\"https://player.vimeo.com/video/22439234\" width=\"640\" height=\"360\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen></iframe>"
  end

  test "generate Vimeo embed HTML with params" do
    html =
      Vimeo.html(@video,
        width: 500,
        height: 500,
        color: "ff0000",
        title: false,
        byline: false,
        autoplay: true,
        loop: true
      )

    assert html ==
             "<iframe src=\"https://player.vimeo.com/video/22439234?autoplay=1&byline=0&color=ff0000&loop=1&title=0\" width=\"500\" height=\"500\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen></iframe>"
  end
end

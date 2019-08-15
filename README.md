# Videx

Videx is a simple video url parser for parsing and generating video urls.

## Usage

Parse Youtube video url.

```elixir
Videx.parse("https://www.youtube.com/watch?v=Hh9yZWeTmVM")
# %Videx.Youtube{id: "Hh9yZWeTmVM", params: %{}, type: :long}
```

Generate Youtube video url.

```elixir
video = %Videx.Youtube{id: "Hh9yZWeTmVM"}
Videx.Youtube.generate(video, :long)
# "https://www.youtube.com/watch?v=Hh9yZWeTmVM"
```

Here is how you can convert Youtube video url to another format.

```elixir
"https://www.youtube.com/watch?v=Hh9yZWeTmVM"
|> Videx.parse()
|> Videx.Youtube.generate(:short)
# "https://youtu.be/Hh9yZWeTmVM"
```

## Installation

Add Videx to your `mix.exs`:

```elixir
def deps do
  [
    {:videx, "~> 0.1.0"}
  ]
end
```
After that, run `mix deps.get`.

## Features

Current Features or To-Do

- [x] Supports: parse and generate url for
  - [x] [YouTube](https://www.youtube.com/)
  - [ ] [Vimeo](https://vimeo.com/)
  - [ ] [Twitch](https://www.twitch.tv/)
  - [ ] [SoundCloud](https://soundcloud.com/)
  - [ ] [Youku](https://www.youku.com/)
  - [ ] [Coub](https://coub.com/)
  - [ ] [Wistia](https://wistia.com/)

## License

Videx is under MIT license. Check the LICENSE file for more details.

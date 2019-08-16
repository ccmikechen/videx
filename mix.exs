defmodule Videx.MixProject do
  use Mix.Project

  @description "Videx is a simple video url parser."
  @version "0.2.0"

  def project do
    [
      app: :videx,
      name: "Videx",
      description: @description,
      version: @version,
      elixir: ">= 1.4.0",
      package: package(),
      deps: deps(),
      source_url: "https://github.com/ccmikechen/videx"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    %{
      maintainers: ["Mike Chen"],
      licenses: ["MIT"],
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      links: %{
        "GitHub" => "https://github.com/ccmikechen/videx"
      }
    }
  end
end

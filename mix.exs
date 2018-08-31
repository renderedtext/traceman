defmodule Traceman.Mixfile do
  use Mix.Project

  def project do
    [
      app: :traceman,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.0", only: :test},
      {:plug, "~> 1.0", only: :test}
    ]
  end
end

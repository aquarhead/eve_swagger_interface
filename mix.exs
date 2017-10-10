defmodule EVESwaggerInterface.Mixfile do
  use Mix.Project

  def project do
    [
      app: :eve_swagger_interface,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:tesla, "~> 0.9"},
      {:poison, "~> 3.1"},
      {:hackney, "~> 1.9"},
    ]
  end
end

defmodule OSC.Mixfile do
  use Mix.Project

  def project do
    [
      app: :osc,
      version: "0.0.1",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      name: "OSC",
      source_url: "https://github.com/lpil/osc",
      description: "Open Sound Control for Elixir",
      package: [
        contributors: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{ "GitHub" => "https://github.com/lpil/osc" },
        files: ~w(mix.exs lib README.md LICENCE)
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger],
      # mod: {OSC, []},
   ]
  end

  defp deps do
    [
      {:excheck, only: :test},
      {:triq, github: "krestenkrab/triq", only: :test},
      {:mix_test_watch, "~> 0.1.1"},
    ]
  end
end

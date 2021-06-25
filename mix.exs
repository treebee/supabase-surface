defmodule SupabaseSurface.MixProject do
  use Mix.Project

  @version "0.2.0"
  def project do
    [
      app: :supabase_surface,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers() ++ [:surface],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: [
        name: "supabase_surface",
        description: "Supabase UI for Surface",
        licenses: ["Apache-2.0"],
        links: %{github: "https://github.com/treebee/supabase_surface"},
        files:
          ~w(lib .formatter.exs mix.exs README.md assets/js assets/css priv/static assets/package.json LICENSE package.json)
      ],
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
        "guides/introduction/installation.md",
        "guides/realtime.md",
        "guides/images.md"
      ],
      extra_section: "GUIDES",
      groups_for_modules: [
        Components: [
          SupabaseSurface.Components.Auth,
          SupabaseSurface.Components.Badge,
          SupabaseSurface.Components.Button,
          SupabaseSurface.Components.Divider,
          SupabaseSurface.Components.Dropdown,
          SupabaseSurface.Components.Typography.Text,
          SupabaseSurface.Components.Typography.Title,
          SupabaseSurface.Components.Typography.Link
        ],
        Plugs: [
          SupabaseSurface.Plugs.Session
        ]
      ],
      groups_for_extras: [
        Introduction: ~r/guides\/introduction\/.?/,
        Guides: ~r/guides\/[^\/]+\.md/
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib"] ++ catalogues()
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.8"},
      {:phoenix_live_view, "~> 0.15.1"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: [:dev, :test]},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:surface_catalogue, "~> 0.1.0", only: [:dev, :test]},
      {:surface, "~> 0.5.0"},
      {:supabase, "~> 0.1.0"},
      {:heroicons, "~> 0.2.2"},
      {:joken, "~> 2.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:feathericons, "~> 0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      dev: "run --no-halt dev.exs"
    ]
  end

  def catalogues() do
    [
      "priv/catalogue"
    ]
  end
end

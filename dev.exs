Logger.configure(level: :debug)

# Start the catalogue server
Surface.Catalogue.Server.start(
  code_reloader: true,
  live_reload: [
    patterns: [
      ~r"lib/supabase_surface/(components|plugs)/.*(ex|js)$",
      ~r"priv/catalogue/components/.*(ex)$"
    ]
  ]
)

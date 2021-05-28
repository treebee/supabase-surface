defmodule SupabaseSurface.Catalogue do
  use Surface.Catalogue

  load_asset "../static/css/app.css", as: :css
  load_asset "../static/js/supabase_surface.js", as: :js

  @impl true
  def config() do
    [
      head_css: """
      <style>#{@css}</style>
      <link href="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" rel="stylesheet">
      """,
      head_js: "<script>#{@js}</script>"
    ]
  end
end

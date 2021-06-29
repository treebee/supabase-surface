defmodule SupabaseSurface.Catalogue do
  use Surface.Catalogue

  load_asset("../static/css/app.css", as: :css)
  load_asset("../static/js/supabase_surface.js", as: :js)

  @impl true
  def config() do
    [
      head_css: """
      <link href="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" rel="stylesheet">
      <style>#{@css}</style>
      """,
      head_js: "<script>#{@js}</script>",
      example: [
        body: [
          class: "p-2 h-full bg-dark-700 dark text-gray-200"
        ]
      ]
    ]
  end
end

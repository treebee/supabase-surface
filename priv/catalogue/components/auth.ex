defmodule SupabaseSurface.Components.Auth.MagicLink do
  use Surface.Catalogue.Example,
    #catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Auth,
    height: "500px"

    alias SupabaseSurface.Components.Auth

    def render(assigns) do
      ~H"""
      <Auth id="supabase-auth" />
      """
    end
end

defmodule SupabaseSurface.Components.Auth.Social do
  use Surface.Catalogue.Example,
    #catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Auth,
    height: "500px"

    alias SupabaseSurface.Components.Auth

    def render(assigns) do
      ~H"""
      <Auth id="supabase-auth" magic_link={{ false }} providers={{ ["github", "google"] }} />
      """
    end
end

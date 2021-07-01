defmodule SupabaseSurface.Components.Auth.Full do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Auth,
    height: "700px",
    title: "Complete Example"

  alias SupabaseSurface.Components.Auth

  def render(assigns) do
    ~F"""
    <Auth id="supabase-auth" password_login={true} providers={["google", "github", "twitter"]} />
    """
  end
end

defmodule SupabaseSurface.Components.Auth.MagicLink do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Auth,
    height: "300px",
    title: "Only Magic Link"

  alias SupabaseSurface.Components.Auth

  def render(assigns) do
    ~F"""
    <Auth id="supabase-auth" />
    """
  end
end

defmodule SupabaseSurface.Components.Auth.Social do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Auth,
    height: "300px",
    title: "Only Social Providers"

  alias SupabaseSurface.Components.Auth

  def render(assigns) do
    ~F"""
    <Auth id="supabase-auth" magic_link={false} providers={["github", "google"]} />
    """
  end
end

defmodule SupabaseSurface.Catalogue.Icons do
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Icon.IconContainer,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  alias SupabaseSurface.Components.Icons.IconActivity
  alias SupabaseSurface.Components.Icons.IconAlertCircle
  alias SupabaseSurface.Components.Icons.IconYoutube

  def render(assigns) do
    ~F"""
    <div class="flex gap-2">
      <IconActivity background="brand" />
      <IconAlertCircle background="purple" />
      <IconYoutube background="red" />
    </div>
    """
  end
end

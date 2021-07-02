defmodule SupabaseSurface.Catalogue.Icons do
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Icon.IconContainer,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  alias SupabaseSurface.Components.IconActivity
  alias SupabaseSurface.Components.IconAlertCircle

  def render(assigns) do
    ~F"""
    <div class="flex">
      <IconActivity background="brand" />
      <IconAlertCircle background="purple" />
    </div>
    """
  end
end

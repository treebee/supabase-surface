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

defmodule SupabaseSurface.Catalogue.Icons.Size do
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Icon.IconContainer,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px",
    title: "Icon Size"

  alias SupabaseSurface.Components.Icons.IconActivity
  alias SupabaseSurface.Components.Icons.IconAlertCircle
  alias SupabaseSurface.Components.Icons.IconYoutube

  def render(assigns) do
    ~F"""
    <div class="block">
      <IconActivity background="brand" size="large" />
      <IconAlertCircle background="purple" size="xlarge" />
      <IconYoutube background="red" size="xxlarge" />
    </div>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconInstagram do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.instagram(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

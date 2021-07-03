defmodule SupabaseSurface.Components.Icons.IconRotateCw do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.rotate_cw(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconMusic do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.music(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

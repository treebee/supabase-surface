defmodule SupabaseSurface.Components.Icons.IconZap do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.zap(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

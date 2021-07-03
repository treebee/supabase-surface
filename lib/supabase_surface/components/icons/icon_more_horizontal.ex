defmodule SupabaseSurface.Components.Icons.IconMoreHorizontal do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.more_horizontal(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

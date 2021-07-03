defmodule SupabaseSurface.Components.Icons.IconSettings do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.settings(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconAlertTriangle do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.alert_triangle(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

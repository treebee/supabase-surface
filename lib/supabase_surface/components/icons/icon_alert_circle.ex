defmodule SupabaseSurface.Components.Icons.IconAlertCircle do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.alert_circle(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

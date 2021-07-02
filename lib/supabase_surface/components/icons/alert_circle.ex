defmodule SupabaseSurface.Components.IconAlertCircle do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.alert_circle()}
    </IconContainer>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconArrowRightCircle do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.arrow_right_circle(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconPlay do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.play(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

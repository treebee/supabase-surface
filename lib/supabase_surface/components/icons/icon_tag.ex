defmodule SupabaseSurface.Components.Icons.IconTag do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.tag(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

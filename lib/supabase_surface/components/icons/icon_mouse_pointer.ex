defmodule SupabaseSurface.Components.Icons.IconMousePointer do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.mouse_pointer(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

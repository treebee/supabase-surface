defmodule SupabaseSurface.Components.Icons.IconUnderline do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.underline(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

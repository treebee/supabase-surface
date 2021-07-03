defmodule SupabaseSurface.Components.Icons.IconShuffle do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.shuffle(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

defmodule SupabaseSurface.Components.Icons.IconUserMinus do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.user_minus(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

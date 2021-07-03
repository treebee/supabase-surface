defmodule SupabaseSurface.Components.Icons.IconCodesandbox do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.codesandbox(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

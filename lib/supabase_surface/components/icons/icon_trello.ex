defmodule SupabaseSurface.Components.Icons.IconTrello do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.trello(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

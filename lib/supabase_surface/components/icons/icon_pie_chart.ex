defmodule SupabaseSurface.Components.Icons.IconPieChart do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.pie_chart(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

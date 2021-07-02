defmodule SupabaseSurface.Components.IconActivity do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.activity()}
    </IconContainer>
    """
  end
end

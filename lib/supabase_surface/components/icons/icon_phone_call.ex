defmodule SupabaseSurface.Components.Icons.IconPhoneCall do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.phone_call(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

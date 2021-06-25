defmodule SupabaseSurface.Components.Divider.Content do
  @moduledoc """
  ## Divider with content

  """
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Divider,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  def render(assigns) do
    ~F"""
    <div class="p-4">
      <Divider> some text </Divider>
    </div>
    """
  end
end

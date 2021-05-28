defmodule SupabaseSurface.Components.Divider.Content do
  @moduledoc """
  ## Divider with content

  """
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Divider,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-dark-800">
      <Divider light={{ true }}> some text </Divider>
    </div>
    """
  end
end

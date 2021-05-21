defmodule SupabaseSurface.Components.TextInput do
  use Surface.Components.Form.Input

  alias Surface.Components.Form.TextInput

  def render(assigns) do
    TextInput.render(assigns)
  end
end

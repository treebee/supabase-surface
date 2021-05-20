defmodule SupabaseSurface.Components.Button do
  use Surface.Component

  @doc "The size of the button"
  prop size, :string, values: ["tiny", "small", "medium", "large", "xlarge"], default: "tiny"

  @doc "The button type"
  prop type, :string,
    values: ["primary", "default", "secondary", "outline", "dashed", "link", "text"],
    default: "primary"

  @doc "The content"
  slot default

  @impl true
  def render(assigns) do
    ~H"""
    <button
      class={{ build_classes(assigns) }}>
      <slot />
    </button>
    """
  end

  defp build_classes(assigns) do
    classes = [
      "sbui-btn",
      "sbui-btn-container",
      "sbui-btn-#{assigns.type}",
      "sbui-btn--#{assigns.size}"
    ]

    Enum.join(classes, " ")
  end
end

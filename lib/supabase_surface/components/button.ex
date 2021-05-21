# some code directly taken from Surface
# https://github.com/surface-ui/surface/blob/master/lib/surface/components/link/button.ex
defmodule SupabaseSurface.Components.Button do
  use Surface.Component
  use Surface.Components.Events

  import Surface.Components.Utils

  @doc "The size of the button"
  prop size, :string, values: ["tiny", "small", "medium", "large", "xlarge"], default: "tiny"

  @doc "The button type"
  prop type, :string,
    values: ["primary", "default", "secondary", "outline", "dashed", "link", "text"],
    default: "primary"

  @doc "Use the full width"
  prop block, :boolean, default: false

  @doc """
  The label for the generated `<button>` element, if no content (default slot) is provided.
  """
  prop label, :string

  @doc "The content of the generated `<button>` element"
  slot default

  @doc "Class or classes to apply to the button"
  prop class, :css_class

  @doc "Additional attributes to add onto the generated element"
  prop opts, :keyword, default: []

  @impl true
  def update(assigns, socket) do
    valid_label!(assigns)
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    opts = assigns.opts ++ events_to_opts(assigns)
    attrs = opts_to_attrs(opts)

    ~H"""
    <button
      class={{ @class, build_classes(assigns) }}
      :attrs={{ attrs }}
    >
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

    classes = if assigns.block, do: ["sbui-btn--w-full" | classes], else: classes

    Enum.join(classes, " ")
  end

  defp valid_label!(assigns) do
    unless assigns[:default] || assigns[:label] || Keyword.get(assigns.opts, :label) do
      raise ArgumentError, "<Button /> requires a label prop or contents in the default slot"
    end
  end
end

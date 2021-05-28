defmodule SupabaseSurface.Components.Typography.Link do
  use Surface.Component

  import Surface.Components.Utils

  @doc "The url to link to"
  prop href, :string

  @doc "The target for the link"
  prop target, :string,
    values: ["_blank", "_self", "_parent", "_top", "framename"],
    default: "_blank"

  @doc "The link text"
  slot default, required: true

  @doc "Additional CSS classes"
  prop class, :css_class

  @doc "Click event for the link"
  prop click, :event

  @doc "Additional options passed to the element"
  prop opts, :keyword, default: []

  @impl true
  def render(assigns) do
    classes = ["sbui-typography", "sbui-typography-link"]
    attrs = opts_to_attrs(assigns.opts)

    ~H"""
    <a class={{ classes, @class }} target={{ @target }} href={{ @href }} rel="noopener noreferrer" :on-click={{ @click }} :attrs={{ attrs }}>
      <slot />
    </a>
    """
  end
end

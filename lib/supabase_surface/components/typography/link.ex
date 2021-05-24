defmodule SupabaseSurface.Components.Typography.Link do
  use Surface.Component

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

  @impl true
  def render(assigns) do
    classes = ["sbui-typography", "sbui-typography-link"]

    ~H"""
    <a class={{ classes, @class }} target={{ @target }} href={{ @href }} rel="noopener noreferrer" :on-click={{ @click }}>
      <slot />
    </a>
    """
  end
end

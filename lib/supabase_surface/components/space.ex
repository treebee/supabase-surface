defmodule SupabaseSurface.Components.Space do
  use Surface.Component

  import Surface.Components.Utils
  import SupabaseSurface.Components.Utils

  slot default

  prop direction, :string, values: ["vertical", "horizontal"], default: "horizontal"

  prop size, :integer, default: 2

  prop class, :css_class

  prop block, :boolean, default: false

  prop minus, :boolean, default: false

  prop style, :keyword, default: []

  prop opts, :keyword, default: []

  def render(assigns) do
    classes = build_classes(assigns)
    attrs = opts_to_attrs(assigns.opts)
    style = get_style(assigns)

    ~F"""
    <div class={@class, classes} :attrs={attrs} style={style}><#slot /></div>
    """
  end

  defp build_classes(assigns) do
    classes = [direction_class(assigns.direction)]

    classes = [
      "sbui-#{minus(assigns.minus)}space-#{direction(assigns.direction)}-#{assigns.size}"
      | classes
    ]

    if assigns.block, do: ["sbui-space--block" | classes], else: classes
  end

  defp minus(true), do: "minus-"
  defp minus(false), do: ""

  defp direction("vertical"), do: "y"
  defp direction("horizontal"), do: "x"

  defp direction_class("vertical"), do: "sbui-space-col"
  defp direction_class("horizontal"), do: "sbui-space-row"
end

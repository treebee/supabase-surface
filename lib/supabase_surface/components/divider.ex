defmodule SupabaseSurface.Components.Divider do
  use Surface.Component

  @doc "If `light` style should be used."
  prop light, :boolean, default: false

  @doc "The orientation in case content is provided"
  prop orientation, :string, values: ["left", "right", "center"], default: "center"

  @doc "The divider type"
  prop type, :string, values: ["horizontal", "vertical"], default: "horizontal"

  @doc "CSS classes to apply to the divider"
  prop class, :css_class

  @doc "The content"
  slot default, required: false

  @impl true
  def render(assigns) do
    classes = [type_class(assigns.type), light_class(assigns.light)]
    default_slot = Map.get(assigns.__surface__.slots, :default, %{}) |> Map.get(:size, 0)
    has_content = default_slot > 0

    classes =
      if has_content do
        ["sbui-divider--#{assigns.orientation}" | classes]
      else
        if assigns.type == "horizontal", do: ["sbui-divider--no-text" | classes], else: classes
      end

    ~H"""
    <div class={{ @class, classes }} role="seperator">
      <span :if={{ has_content }} class="sbui-divider__content">
        <slot />
      </span>
    </div>
    """
  end

  defp type_class("horizontal"), do: "sbui-divider"
  defp type_class("vertical"), do: "sbui-divider-vertical"

  defp light_class(true), do: "sbui-divider--light"
  defp light_class(false), do: ""
end

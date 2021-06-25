defmodule SupabaseSurface.Components.Badge do
  use Surface.Component

  @doc "The color for the badge"
  prop color, :string,
    values: ["gray", "red", "yellow", "green", "blue", "indigo", "purple", "pink"]

  @doc "The size of the badge"
  prop size, :string, values: ["large", "small"], default: "small"

  @doc ""
  prop dot, :boolean, default: false

  @doc "Content of the badge"
  slot default, required: true

  @impl true
  def render(assigns) do
    classes = ["sbui-badge"]

    classes =
      if is_nil(assigns.color), do: classes, else: ["sbui-badge--#{assigns.color}" | classes]

    classes = if assigns.size == "large", do: ["sbui-badge--large" | classes], else: classes

    ~F"""
    <span class={classes}>{render_dot(assigns)}<#slot /></span>
    """
  end

  def render_dot(%{dot: false}), do: ""

  def render_dot(%{dot: true} = assigns) do
    ~F"""
    <svg class={"sbui-badge-dot sbui-badge--#{@color}"}
      fill="currentColor"
      viewBox="0 0 8 8"
    >
      <circle cx="4" cy="4" r="3" />
    </svg>
    """
  end
end

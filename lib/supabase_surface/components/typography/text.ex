defmodule SupabaseSurface.Components.Typography.Text do
  use Surface.Component

  @doc "The type (color) of the text"
  prop type, :atom, values: [:default, :success, :danger, :secondary, :warning]

  @doc "Apply `disabled` style"
  prop disabled, :boolean, default: false

  @doc "Apply `underline` style"
  prop underline, :boolean, default: false

  @doc "Apply `strikethrough` style"
  prop strikethrough, :boolean, default: false

  @doc "Apply `small` style"
  prop small, :boolean, default: false

  @doc "CSS classes to apply"
  prop class, :css_class

  @doc "Which html tag to use for enclosing the tag"
  prop html_type, :string, values: ["span", "kbd", "code", "mark", "strong"], default: "span"

  @doc "The content"
  slot default, required: true

  @impl true
  def render(assigns) do
    classes = build_classes(assigns)

    render_text(classes, assigns)
  end

  def render_text(classes, %{html_type: "span"} = assigns) do
    ~H"""
    <span class={{ classes, @class }}><slot /></span>
    """
  end

  def render_text(classes, %{html_type: "kbd"} = assigns) do
    ~H"""
    <kbd class={{ classes, @class }}><slot /></kbd>
    """
  end

  def render_text(classes, %{html_type: "code"} = assigns) do
    ~H"""
    <code class={{ classes, @class }}><slot /></code>
    """
  end

  def render_text(classes, %{html_type: "mark"} = assigns) do
    ~H"""
    <mark class={{ classes, @class }}><slot /></mark>
    """
  end

  def render_text(classes, %{html_type: "strong"} = assigns) do
    ~H"""
    <strong class={{ classes, @class }}><slot /></strong>
    """
  end

  defp build_classes(assigns) do
    classes = ["sbui-typography-text"]

    classes =
      if not is_nil(assigns.type),
        do: classes ++ ["sbui-typography-text-#{assigns.type}"],
        else: classes

    classes =
      if assigns.disabled,
        do: classes ++ ["sbui-typography-text-disabled"],
        else: classes

    classes =
      if assigns.underline,
        do: classes ++ ["sbui-typography-text-underline"],
        else: classes

    classes =
      if assigns.strikethrough,
        do: classes ++ ["sbui-typography-text-strikethrough"],
        else: classes

    classes =
      if assigns.small,
        do: classes ++ ["sbui-typography-text-small"],
        else: classes

    classes
  end
end

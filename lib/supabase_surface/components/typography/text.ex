defmodule SupabaseSurface.Components.Typography.Text do
  use Surface.Component

  import Surface.Components.Utils

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

  @doc "Additional options passed to the element"
  prop opts, :keyword, default: []

  @doc "The content"
  slot default, required: true

  @impl true
  def render(assigns) do
    classes = build_classes(assigns)
    attrs = opts_to_attrs(assigns.opts)
    render_text(classes, assigns, attrs)
  end

  def render_text(classes, %{html_type: "span"} = assigns, attrs) do
    ~H"""
    <span class={{ classes, @class }} :attrs={{ attrs }}><slot /></span>
    """
  end

  def render_text(classes, %{html_type: "kbd"} = assigns, attrs) do
    ~H"""
    <kbd class={{ classes, @class }} :attrs={{ attrs }}><slot /></kbd>
    """
  end

  def render_text(classes, %{html_type: "code"} = assigns, attrs) do
    ~H"""
    <code class={{ classes, @class }} :attrs={{ attrs }}><slot /></code>
    """
  end

  def render_text(classes, %{html_type: "mark"} = assigns, attrs) do
    ~H"""
    <mark class={{ classes, @class }} :attrs={{ attrs }}><slot /></mark>
    """
  end

  def render_text(classes, %{html_type: "strong"} = assigns, attrs) do
    ~H"""
    <strong class={{ classes, @class }} :attrs={{ attrs }}><slot /></strong>
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

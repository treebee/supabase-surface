# some code directly taken from Surface
# https://github.com/surface-ui/surface/blob/master/lib/surface/components/link/button.ex
defmodule SupabaseSurface.Components.Button do
  @moduledoc """
  A html **button** with predefined sizes, types and optional `link` functionality.
  """
  use Surface.Component
  use Surface.Components.Events

  import Surface.Components.Utils

  @doc "The html type of the button, e.g. 'submit', 'button' or 'reset'"
  prop html_type, :string, values: ["submit", "button", "reset"], default: "button"

  @doc "The aria label for the button"
  prop aria_label, :string, required: false

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

  @doc "The page to link to"
  prop to, :string

  @doc "The method to use when used as a link"
  prop method, :atom, default: :post

  @doc "Id to apply to the button"
  prop id, :string

  @doc "Class or classes to apply to the button"
  prop class, :css_class

  @doc "Additional attributes to add onto the generated element"
  prop opts, :keyword, default: []

  @doc "If the button should be disabled"
  prop disabled, :boolean, default: false

  @doc "Apply loading state"
  prop loading, :boolean, default: false

  @doc "The content of the generated `<button>` element"
  slot default

  @impl true
  def update(assigns, socket) do
    valid_label!(assigns)
    {:ok, assign(socket, assigns)}
  end

  defp apply_method(nil, _, opts), do: opts

  defp apply_method(to, method, opts) do
    to = valid_destination!(to, "<Button />")

    if method == :get do
      opts = skip_csrf(opts)
      [data: [method: method, to: to]] ++ opts
    else
      {csrf_data, opts} = csrf_data(to, opts)
      [data: [method: method, to: to] ++ csrf_data] ++ opts
    end
  end

  @impl true
  def render(assigns) do
    opts = apply_method(assigns.to, assigns.method, assigns.opts) ++ events_to_opts(assigns)
    attrs = opts_to_attrs(opts)

    container_classes = ["sbui-btn-container"]

    container_classes =
      if assigns.block do
        ["sbui-btn--w-full" | container_classes]
      else
        container_classes
      end

    ~F"""
    <span class={Enum.join(container_classes, " ")}>
      <button
        id={@id}
        type={@html_type}
        class={build_classes(assigns), @class, "flex gap-2": @loading}
        aria_label={@aria_label}
        :attrs={attrs}
        disabled={@loading or @disabled}
      ><div :if={@loading} class="sbui-icon-container sbui-btn--anim--spin">{Feathericons.loader(class: "w-4 h-4")}</div><span><#slot /></span></button>
    </span>
    """
  end

  defp build_classes(assigns) do
    classes = [
      "sbui-btn",
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

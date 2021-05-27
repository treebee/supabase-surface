defmodule SupabaseSurface.Components.DropdownItemIcon do
  @moduledoc """
  This component is used together with DropdownItem to add an icon
  to the dropdown item.

  ## Example

      <DropdownItem to="/logout" method={{ :post }}>
        <DropdownItemIcon>{{ Heroicons.Outline.logout(class: "w-4 h-4") }}</DropdownItemIcon>
        <Typography.Text>Logout</Typography.text>
      </DropdownItem>
  """
  use Surface.Component, slot: "icon"

  slot default, required: true

  def render(assigns) do
    ~H"""
    <slot />
    """
  end
end

defmodule SupabaseSurface.Components.DropdownItem do
  use Surface.Component, slot: "items"

  import Surface.Components.Utils
  alias Surface.Components.LivePatch

  @doc "When provided, the dropdown item will serve as a link using LivePatch for method :get and a <button /> for :post"
  prop to, :string

  @doc "The method to use when used as a link"
  prop method, :atom, default: :get

  @doc "Additional options passed to the component"
  prop opts, :keyword, default: []

  slot default, required: true

  @doc "An optional icon for this dropdown item. See DropdownItemIcon."
  slot icon, required: false

  @doc "Additional CSS class(es) to apply to the dropdown item"
  prop class, :css_class

  @impl true
  def render(assigns) do
    ~H"""
    <div tabindex="-1" class={{ "flex align-center sbui-dropdown-item", @class }} role="menuitem">
      <slot name="icon" />
      <span class="sbui-dropdown-item__content">
        {{ render_content(assigns) }}
      </span>
    </div>
    """
  end

  def render_content(%{to: nil} = assigns) do
    ~H"""
      <slot />
    """
  end

  def render_content(%{to: to, method: :get} = assigns) do
    ~H"""
    <LivePatch to={{ to }} class="flex items-center">
      <slot />
    </LivePatch>
    """
  end

  def render_content(%{to: to, method: method} = assigns) do
    opts = apply_method(to, method, assigns.opts)
    attrs = opts_to_attrs(opts)

    ~H"""
    <button :attrs={{ attrs }} class="flex items-center">
      <slot />
    </button>
    """
  end

  defp apply_method(nil, _, opts), do: opts

  defp apply_method(to, method, opts) do
    to = valid_destination!(to, "<DropboxItem />")

    if method == :get do
      opts = skip_csrf(opts)
      [data: [method: method, to: to]] ++ opts
    else
      {csrf_data, opts} = csrf_data(to, opts)
      [data: [method: method, to: to] ++ csrf_data] ++ opts
    end
  end
end

defmodule SupabaseSurface.Components.Dropdown do
  @moduledoc """
  A **dropdown** component using [alpinejs](https://github.com/alpinejs/alpine).

  The Dropdown defines an Alpine.js block and initializes a variable `open: false`
  indicating if the dropdown should be open.
  The default slot is used for the activator of the dropdown, for example a <button />,
  which needs to add the alpine click handlers. See example below:

  ## Example

      <Dropdown id="user-menu"
        transition={{
          enter: "transition ease-out origin-top-left duration-200",
          enter_start: "opacity-0 transform scale-90",
          enter_end: "opacity-100 transform scale-100",
          leave: "transition origin-top-left ease-in duration-100",
          leave_start: "opacity-100 transform scale-100",
          leave_end: "opacity-0 transform scale-90"
        }}
      >
        <DropdownItem to="/profile">
          <DropdownItemIcon>{{ Heroicons.Outline.user(class: "w-4 h-4") }}</DropdownItemIcon>
          <Typography.Text>Profile</Typography.Text>
        </DropdownItem>
        <DropdownItem to="/logout" method={{ :post }}>
          <DropdownItemIcon>{{ Heroicons.Outline.logout(class: "w-4 h-4") }}</DropdownItemIcon>
          <Typography.Text>Logout</Typography.Text>
        </DropdownItem>
        <Button
          type="link"
          opts={{ "@click": "open = !open", "@click.away": "open = false", "@keydown.escape.window": "open = false" }}
        >
          Click me
        </Button>
      </Dropdown>

  Note: Alpine.js is used here to avoid needing a complete server roundtrip just to open the dropdown.
  As a result this can provide better UX.

  """

  use Surface.Component

  @doc "The dropdown items"
  slot items, required: true

  @doc "The clickable element activating the dropdown"
  slot default, required: true

  @doc "Tailwind transition classes to apply to the dropdown."
  prop transition, :keyword, default: []

  @doc "Where to put the dropdown"
  prop side, :string, values: ["top", "bottom", "left", "right"], default: "bottom"

  @doc "How to align the dropdown"
  prop align, :string, values: ["start", "end", "center"], default: "center"

  @impl true
  def render(assigns) do
    ~H"""
      <div
        x-data="{ open: false }"
        class="relative inline-block">
          <slot
            @click="open = !open"
            @click.away="open = false"
          />
        <div
          x-cloak
          x-show="open"
          x-transition:enter={{ Keyword.get(@transition, :enter, nil)}}
          x-transition:enter-start={{ Keyword.get(@transition, :enter_start, nil)}}
          x-transition:enter-end={{ Keyword.get(@transition, :enter_end, nil)}}
          x-transition:leave-start={{ Keyword.get(@transition, :leave_start, nil)}}
          x-transition:leave-end={{ Keyword.get(@transition, :leave_end, nil)}}
          class={{ "absolute z-10 sbui-dropdown__content", position_class(@side, @align) }}
          role="menu" aria-orientation="vertical" data-orientation="vertical"
        >
          <slot :for.index={{ @items }} name="items" index={{ index }} />
       </div>
      </div>
    """
  end

  defp position_class("bottom", "center"), do: "left-1/2 transform -translate-x-1/2 mt-2"
  defp position_class("bottom", "start"), do: "mt-2"
  defp position_class("bottom", "end"), do: "right-0 mt-2"
  defp position_class("top", "center"), do: "left-1/2 transform -translate-x-1/2 bottom-full mb-2"
  defp position_class("top", "start"), do: "bottom-full mb-2"
  defp position_class("top", "end"), do: "bottom-full right-0 mb-2"
  defp position_class("right", "center"), do: "top-1/2 left-full transform -translate-y-1/2 ml-2"
  defp position_class("left", "center"), do: "top-1/2 right-full transform -translate-y-1/2 mr-2"
end

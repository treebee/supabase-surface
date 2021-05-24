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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex align-center sbui-dropdown-item" role="menuitem">
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

  use Surface.LiveComponent

  @doc "The dropdown items"
  slot items, required: true

  @doc "The clickable element activating the dropdown"
  slot default, required: true

  @doc "Tailwind transition classes to apply to the dropdown."
  prop transition, :keyword

  @doc "A tailwind class for `right/left` positioning of the dropdown, e.g. `right-0.5` or `-left-1`"
  prop x_position, :string

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div
        x-data="{ open: false }"
        class="relative">
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
          class={{ "absolute mt-2 z-10 sbui-dropdown__content", @x_position }}
          role="menu" aria-orientation="vertical" data-orientation="vertical"
        >
          <div :for.index={{ @items }} class="hover:bg-dark-600">
            <slot name="items" index={{ index }} />
          </div>
       </div>
      </div>
    </div>
    """
  end
end

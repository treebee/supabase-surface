defmodule SupabaseSurface.Components.Dropdown.Menu do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Dropdown,
    height: "500px"

    alias SupabaseSurface.Components.Button
    alias SupabaseSurface.Components.Divider
    alias SupabaseSurface.Components.Dropdown
    alias SupabaseSurface.Components.DropdownItem
    alias SupabaseSurface.Components.DropdownItemIcon
    alias SupabaseSurface.Components.Typography

    def render(assigns) do
      ~H"""
      <Dropdown
        transition={{
          enter: "transition ease-out origin-top-left duration-200",
          enter_start: "opacity-0 transform scale-90",
          enter_end: "opacity-100 transform scale-100",
          leave: "transition origin-top-left ease-in duration-100",
          leave_start: "opacity-100 transform scale-100",
          leave_end: "opacity-0 transform scale-90"
        }}
      >
        <DropdownItem to="#" class="hover:bg-gray-300">
          <DropdownItemIcon>{{ Heroicons.Outline.user(class: "w-4 h-4") }}</DropdownItemIcon>
          <Typography.Text>Profile</Typography.Text>
        </DropdownItem>
        <DropdownItem to="#" class="hover:bg-gray-300">
          <DropdownItemIcon>{{ Heroicons.Outline.cog(class: "w-4 h-4") }}</DropdownItemIcon>
          <Typography.Text>Settings</Typography.Text>
        </DropdownItem>
        <template slot="items">
          <Divider light={{ true }} />
        </template>
        <DropdownItem to="#" method={{ :post }} class="hover:bg-gray-300">
          <DropdownItemIcon>{{ Heroicons.Outline.logout(class: "w-4 h-4") }}</DropdownItemIcon>
          <Typography.Text>Logout</Typography.Text>
        </DropdownItem>
        <Button
          opts={{ "@click": "open = !open", "@click.away": "open = false", "@keydown.escape.window": "open = false" }}
        >
          Click me
        </Button>
      </Dropdown>
      """
    end
end


defmodule SupabaseSurface.Components.Dropdown.Placement do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Dropdown,
    height: "500px"

    alias SupabaseSurface.Components.Button
    alias SupabaseSurface.Components.Divider
    alias SupabaseSurface.Components.Dropdown
    alias SupabaseSurface.Components.DropdownItem
    alias SupabaseSurface.Components.DropdownItemIcon
    alias SupabaseSurface.Components.Typography



    def render(assigns) do
      ~H"""
      <Dropdown :for={{ placement <- ["bottom center", "bottom left", "bottom right", "top center", "top right", "top left", "right center", "left center"] }}
          transition={{
            enter: "transition ease-out origin-top-left duration-200",
            enter_start: "opacity-0 transform scale-90",
            enter_end: "opacity-100 transform scale-100",
            leave: "transition origin-top-left ease-in duration-100",
            leave_start: "opacity-100 transform scale-100",
            leave_end: "opacity-0 transform scale-90"
          }}
          side={{ get_side(placement) }}
          align={{ get_align(placement) }}
        >
          <DropdownItem class="hover:bg-gray-300">
            <DropdownItemIcon>{{ Heroicons.Outline.user(class: "w-4 h-4") }}</DropdownItemIcon>
            <Typography.Text>Profile</Typography.Text>
          </DropdownItem>
          <DropdownItem class="hover:bg-gray-300">
            <DropdownItemIcon>{{ Heroicons.Outline.cog(class: "w-4 h-4") }}</DropdownItemIcon>
            <Typography.Text>Settings</Typography.Text>
          </DropdownItem>
          <template slot="items">
            <Divider light={{ true }} />
          </template>
          <DropdownItem method={{ :post }} class="hover:bg-gray-300">
            <DropdownItemIcon>{{ Heroicons.Outline.logout(class: "w-4 h-4") }}</DropdownItemIcon>
            <Typography.Text>Logout</Typography.Text>
          </DropdownItem>
          <Button
            type="outline"
            opts={{ "@click": "open = !open", "@click.away": "open = false", "@keydown.escape.window": "open = false" }}
          >
            {{ placement }}
          </Button>
        </Dropdown>
      """
    end

    defp get_side(placement) do
      [side, _] = String.split(placement)
      side
    end
    defp get_align(placement) do
      [_, align] = String.split(placement)
      case align do
        "left" -> "end"
        "right" -> "start"
        "center" -> "center"
      end
    end
end

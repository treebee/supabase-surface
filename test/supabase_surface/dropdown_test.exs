defmodule SupabaseSurface.Components.DropdownTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.{Button, Dropdown, DropdownItem}

  # TODO tests where we also check the alpine.js functionality (dropdown closed/open)
  test "renders dropdown with items" do
    html =
      render_surface do
        ~H"""
        <Dropdown>
          <DropdownItem>Settings</DropdownItem>
          <DropdownItem>Logout</DropdownItem>
          <Button
            opts={{ "@click": "open = !open", "@click.away": "open = false", "@keydown.escape.window": "open = false" }}
          >
            open
          </Button>
        </Dropdown>
        """
      end

    assert html =~ "open"
    assert html =~ "Settings"
    assert html =~ "Logout"
  end
end

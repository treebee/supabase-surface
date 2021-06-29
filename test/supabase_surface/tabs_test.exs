defmodule SupabaseSurface.Components.TabsTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.{Tabs, Tab}

  test "renders tabs" do
    html =
      render_surface do
        ~F"""
        <Tabs id="test-tabs">
          <Tab label="Settings">Settings Content</Tab>
          <Tab label="Overview">Overview Content</Tab>
        </Tabs>
        """
      end

    assert html =~ "Settings"
  end
end

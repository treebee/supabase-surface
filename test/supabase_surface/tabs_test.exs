defmodule SupabaseSurface.Components.TabsTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Button
  alias SupabaseSurface.Components.{Tabs, Tab}
  alias SupabaseSurface.Components.Tabs.AddOnBefore

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint Endpoint

  defmodule View do
    use Surface.LiveView

    @impl true
    def render(assigns) do
      ~F"""
        <Tabs id="test-tabs">
          <Tab label="Settings">Settings Content</Tab>
          <Tab label="Overview">Overview Content</Tab>
        </Tabs>
      """
    end
  end

  setup do
    {:ok, view, html} = live_isolated(build_conn(), View)
    %{view: view, html: html}
  end

  test "renders tabs", %{html: html} do
    assert html =~ "Settings Content"
  end

  test "switches tabs on click", %{view: view} do
    assert view
           |> element("button", "Overview")
           |> render_click() =~ "Overview Content"
  end

  test "renders addOnBefore" do
    html =
      render_surface do
        ~F"""
        <Tabs id="tabs">
          <AddOnBefore><Button type="outline">Action button</Button></AddOnBefore>
          <Tab label="Tab one">Tab one content</Tab>
          <Tab label="Tab two">Tab two content</Tab>
        </Tabs>
        """
      end

    assert html =~ "<span>Action button</span>"
  end
end

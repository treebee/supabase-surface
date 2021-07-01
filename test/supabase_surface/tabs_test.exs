defmodule SupabaseSurface.Components.TabsTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.{Tabs, Tab}
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
end

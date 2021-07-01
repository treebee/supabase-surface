defmodule SupabaseSurface.Components.ModalTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Modal

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint Endpoint

  defmodule View do
    use Surface.LiveView

    @impl true
    def render(assigns) do
      ~F"""
      <Modal id="test-modal" title="My Test Modal" description="The Modal description">
        <Modal.Trigger label="Open Modal" />
      </Modal>
      """
    end

    @impl true
    def handle_event("open", _, socket) do
      Modal.open("test-modal")
      {:noreply, socket}
    end
  end

  setup do
    {:ok, view, html} = live_isolated(build_conn(), View)
    %{view: view, html: html}
  end

  test "renders only the modal trigger", %{html: html} do
    assert html =~ "<span>Open Modal</span>"
    refute html =~ "The Modal description"
  end

  test "opens Modal on trigger click", %{view: view} do
    refute view |> has_element?("span", "The Modal description")
    view |> element("button", "Open Modal") |> render_click()
    assert view |> has_element?("span", "The Modal description")
  end

  test "renders custom trigger element" do
    html =
      render_surface do
        ~F"""
        <Modal id="test-modal">
          <Modal.Trigger><span role="button" :on-click="show-modal">Show Modal</span></Modal.Trigger>
        </Modal>
        """
      end

    assert html =~ "<span phx-click=\"show-modal\" role=\"button\">Show Modal</span>"
  end
end

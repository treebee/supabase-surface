defmodule SupabaseSurface.Components.DividerTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Divider

  test "renders divider" do
    html =
      render_surface do
        ~F"""
        <Divider />
        """
      end

    assert html =~ """
           <div class="sbui-divider--no-text sbui-divider" role="seperator">\n</div>
           """
  end

  test "creates a divider with content" do
    html =
      render_surface do
        ~F"""
        <Divider>some text</Divider>
        """
      end

    assert html =~ """
           <div class="sbui-divider--center sbui-divider" role="seperator">\n  <span class="sbui-divider__content">some text</span>\n</div>
           """
  end
end

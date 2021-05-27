defmodule SupabaseSurface.Components.ButtonTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Button

  test "creates a tiny, primary <button> with type button" do
    html =
      render_surface do
        ~H"""
        <Button>my button</Button>
        """
      end

    assert html =~ """
           <button type="button" class="sbui-btn sbui-btn-container sbui-btn-primary sbui-btn--tiny">my button</button>
           """
  end

  test "renders disabled button" do
    html =
      render_surface do
        ~H"""
        <Button disabled={{ true }}>disabled</Button>
        """
      end

    assert html =~ """
           <button type="button" class="sbui-btn sbui-btn-container sbui-btn-primary sbui-btn--tiny" disabled>disabled</button>
           """
  end

  test "includes a link" do
    html =
      render_surface do
        ~H"""
        <Button type="link" to="/settings" method={{ :get }}>Settings</Button>
        """
      end

    assert html =~ """
           <button data-method=\"get\" data-to=\"/settings\" type=\"button\" class=\"sbui-btn sbui-btn-container sbui-btn-link sbui-btn--tiny\">Settings</button>
           """
  end
end

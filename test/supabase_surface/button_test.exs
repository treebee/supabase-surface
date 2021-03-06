defmodule SupabaseSurface.Components.ButtonTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Button

  test "creates a tiny, primary <button> with type button" do
    html =
      render_surface do
        ~F"""
        <Button>my button</Button>
        """
      end

    assert html =~ """
           <span class="sbui-btn-container">
             <button type="button" class="sbui-btn sbui-btn-primary sbui-btn--tiny"><span>my button</span></button>
           </span>
           """
  end

  test "renders disabled button" do
    html =
      render_surface do
        ~F"""
        <Button disabled={true}>disabled</Button>
        """
      end

    assert html =~ """
           <button type="button" class="sbui-btn sbui-btn-primary sbui-btn--tiny" disabled><span>disabled</span></button>
           """
  end

  test "includes a link" do
    html =
      render_surface do
        ~F"""
        <Button type="link" to="/settings" method={:get}>Settings</Button>
        """
      end

    assert html =~ """
           <button data-method=\"get\" data-to=\"/settings\" type=\"button\" class=\"sbui-btn sbui-btn-link sbui-btn--tiny\"><span>Settings</span></button>
           """
  end

  test "loading shows icon and is disabled" do
    html =
      render_surface do
        ~F"""
        <Button loading>Save</Button>
        """
      end

    assert html =~ "disabled"
    assert html =~ "disabled><div class=\"sbui-icon-container sbui-btn--anim--spin\"><svg xmlns="
    assert html =~ "</svg></div><span>Save</span></button>"
  end
end

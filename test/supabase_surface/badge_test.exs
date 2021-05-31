defmodule SupabaseSurface.Components.BadgeTest do
  use SupabaseSurface.ConnCase, async: true

  alias SupabaseSurface.Components.Badge

  test "creates blue badge" do
    html =
      render_surface do
        ~H"""
        <Badge color="blue">my badge</Badge>
        """
      end

    assert html =~ """
           <span class="sbui-badge--blue sbui-badge">my badge</span>
           """
  end

  test "creates badge with dot" do
    html =
      render_surface do
        ~H"""
        <Badge dot color="blue">my badge</Badge>
        """
      end

    assert html =~ "<svg class=\"sbui-badge-dot sbui-badge--blue"
  end

  test "creates large badge" do
    html =
      render_surface do
        ~H"""
        <Badge size="large" color="blue">my badge</Badge>
        """
      end

    assert html =~ """
           <span class="sbui-badge--large sbui-badge--blue sbui-badge">my badge</span>
           """
  end
end

defmodule SupabaseSurface.Components.Typography.Title do
  use Surface.Component

  import SupabaseSurface.Components.Utils

  @doc "The level for the resulting heading"
  prop level, :integer, values: [1, 2, 3, 4, 5], default: 1

  @doc "The title content"
  slot default, required: true

  @doc "Extra CSS classes to apply"
  prop class, :css_class

  @doc "Extra styles"
  prop style, :keyword, default: []

  @impl true
  def render(%{level: 1} = assigns) do
    ~F"""
      <h1 class={"sbui-typography-title", @class} style={get_style(assigns)}><#slot /></h1>
    """
  end

  @impl true
  def render(%{level: 2} = assigns) do
    ~F"""
      <h2 class={"sbui-typography-title", @class} style={get_style(assigns)}><#slot /></h2>
    """
  end

  @impl true
  def render(%{level: 3} = assigns) do
    ~F"""
      <h3 class={"sbui-typography-title", @class} style={get_style(assigns)}><#slot /></h3>
    """
  end

  @impl true
  def render(%{level: 4} = assigns) do
    ~F"""
      <h4 class={"sbui-typography-title", @class} style={get_style(assigns)}><#slot /></h4>
    """
  end

  @impl true
  def render(%{level: 5} = assigns) do
    ~F"""
      <h5 class={"sbui-typography-title", @class} style={get_style(assigns)}><#slot /></h5>
    """
  end
end

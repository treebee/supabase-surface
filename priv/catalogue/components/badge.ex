defmodule SupabaseSurface.Components.Badge.Basic do
  @moduledoc """
  ## Basic Badges

  """
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Badge,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

    alias SupabaseSurface.Components.Badge

    def render(assigns) do
      ~F"""
      <div class="dark p-8 bg-dark-700">
        <Badge color="blue">blue</Badge>
        <Badge color="gray">gray</Badge>
        <Badge color="green">green</Badge>
        <Badge color="indigo">indigo</Badge>
        <Badge color="pink">pink</Badge>
        <Badge color="purple">purple</Badge>
        <Badge color="red">red</Badge>
        <Badge color="yellow">yellow</Badge>
      </div>
      """
    end
end

defmodule SupabaseSurface.Components.Badge.Dot do
  @moduledoc """
  ## With Dot

  """
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Badge,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

    alias SupabaseSurface.Components.Badge

    def render(assigns) do
      ~F"""
      <div class="dark p-8 bg-dark-700">
        <Badge dot color="blue">blue</Badge>
        <Badge dot size="large" color="pink">pink</Badge>
      </div>
      """
    end
end

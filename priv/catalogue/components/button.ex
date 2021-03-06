defmodule SupabaseSurface.Catalogue.Button.Types do
  @moduledoc """
  ## Button Types

  You can define the type of a button using the `type` prop.

  There are `primary`, `secondary`, `default`, `dashed`, `outline`, `text`
  and `link`.

  """
  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Button,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  alias SupabaseSurface.Components.Button

  def render(assigns) do
    ~F"""
    <Button type="primary">Primary Button</Button>
    <Button type="secondary">Secondary Button</Button>
    <Button type="default">Default Button</Button>
    <Button type="dashed">Dashed Button</Button>
    <Button type="outline">Outline Button</Button>
    <Button type="text">Text Button</Button>
    <Button type="link">Link Button</Button>
    """
  end
end

defmodule SupabaseSurface.Catalogue.Button.Size do
  @moduledoc """
  ## Size

  You can define the size of a button using the `size` prop.

  There are `tiny`, `small`, `medium`, `large` and `xlarge`.
  The default is `tiny`.

  """

  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Button,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  alias SupabaseSurface.Components.Button

  def render(assigns) do
    ~F"""
    <Button size="tiny">tiny</Button>
    <Button size="small">small</Button>
    <Button size="medium">medium</Button>
    <Button size="large">large</Button>
    <Button size="xlarge">xlarge</Button>
    """
  end
end

defmodule SupabaseSurface.Catalogue.Button.States do
  @moduledoc """
  ## States

  """

  use Surface.Catalogue.Example,
    subject: SupabaseSurface.Components.Button,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px"

  alias SupabaseSurface.Components.Button

  def render(assigns) do
    ~F"""
    <Button loading type="outline" class="m-2">loading</Button>
    <Button loading size="xlarge" class="m-2">loading</Button>
    <Button disabled class="m-2">disabled</Button>
    """
  end
end

defmodule SupabaseSurface.Catalogue.Button.Playground do
  use Surface.Catalogue.Playground,
    subject: SupabaseSurface.Components.Button,
    catalogue: SupabaseSurface.Catalogue,
    height: "200px",
    container: {:div, class: "dark bg-dark-800"}

  data props, :map, default: %{}

  def render(assigns) do
    ~F"""
    <Button :props={@props}>My Button</Button>
    """
  end
end

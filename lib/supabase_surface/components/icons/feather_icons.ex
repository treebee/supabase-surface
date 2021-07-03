defmodule SupabaseSurface.Components.Icons.FeatherIcons do
  defmacro __before_compile__(_) do
    icon_dir = :code.priv_dir(:feathericons) |> Path.join("icons")
    icon_paths = icon_dir |> Path.join("icons") |> Path.join("*.svg") |> Path.wildcard()

    for path <- icon_paths do
      generate_icon_component(path)
    end
  end

  def generate_icon_component(path) do
    icon_name =
      Path.basename(path, ".svg")
      |> String.replace("-", "_")

    function_name = "Feathericons.#{icon_name}" |> String.to_atom()

    name =
      Path.basename(path, ".svg")
      |> String.split("-")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join()

    quote do
      defmodule unquote(name) do
        use SupabaseSurface.Components.Icon

        def print(), do: "haha"
        # @impl true
        # def render(assigns) do
        #  icon_size = IconContainer.get_size(assigns.size)

        #  ~F"""
        #  <IconContainer assigns={assigns}>
        #    {unquote(function_name)(width: icon_size, height: icon_size)}
        #  </IconContainer>
        #  """
        # end
      end
    end
  end
end

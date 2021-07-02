defmodule SupabaseSurface.Components.Icon do
  defmacro __using__(_) do
    quote do
      use Surface.Component

      import unquote(__MODULE__)
      alias SupabaseSurface.Components.Icon.IconContainer

      prop size, :string,
        values: ["tiny", "small", "medium", "large", "xlarge", "xxlarge", "xxxlarge"],
        default: "large"

      prop icon, :string, required: true

      prop background, :string,
        values: ["brand", "gray", "red", "yellow", "green", "blue", "indigo", "purple", "pink"]
    end
  end

  defmodule IconContainer do
    use Surface.Component

    @doc "The assigns of the host component"
    prop assigns, :map

    slot default

    @impl true
    def render(%{assigns: props} = assigns) do
      icon_size = get_size(props.size)

      container_classes = ["sbui-icon-container"]

      container_classes =
        if is_nil(props.background) do
          container_classes
        else
          container_classes ++ ["sbui-icon-container--#{props.background}"]
        end

      ~F"""
      <div class={Enum.join(container_classes, " ")}>
        <#slot />
      </div>
      """
    end

    defp get_size("tiny"), do: 14
    defp get_size("small"), do: 18
    defp get_size("medium"), do: 20
    defp get_size("large"), do: 20
    defp get_size("xlarge"), do: 24
    defp get_size("xxlarge"), do: 30
    defp get_size("xxxlarge"), do: 42
    defp get_size(_), do: 21
  end
end

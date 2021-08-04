defmodule SupabaseSurface.Components.Icon do
  defmacro __using__(_) do
    quote do
      use Surface.Component

      import unquote(__MODULE__)
      alias SupabaseSurface.Components.Icon.IconContainer

      prop size, :string,
        values: ["tiny", "small", "medium", "large", "xlarge", "xxlarge", "xxxlarge"],
        default: "large"

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
      container_classes = ["sbui-icon-container"]

      container_classes =
        if is_nil(props.background) do
          container_classes
        else
          container_classes ++ ["sbui-icon-container--#{props.background}", "inline-flex"]
        end

      ~F"""
      <div class={Enum.join(container_classes, " ")}>
        <#slot />
      </div>
      """
    end

    def get_size("tiny"), do: 14
    def get_size("small"), do: 18
    def get_size("medium"), do: 20
    def get_size("large"), do: 20
    def get_size("xlarge"), do: 24
    def get_size("xxlarge"), do: 30
    def get_size("xxxlarge"), do: 42
    def get_size(_), do: 21
  end
end

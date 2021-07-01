defmodule SupabaseSurface.Components.Tab do
  use Surface.Component, slot: "tabs"

  prop label, :string, required: true

  slot default, required: true

  def render(assigns) do
    ~F"""
    <#slot />
    """
  end
end

defmodule SupabaseSurface.Components.Tabs do
  use Surface.LiveComponent

  alias SupabaseSurface.Components.Button
  alias SupabaseSurface.Components.Divider
  alias SupabaseSurface.Components.Space
  alias SupabaseSurface.Components.Tab

  prop type, :string, values: ["pills", "underlined", "cards"], default: "pills"
  prop size, :string, values: ["tiny", "small", "medium", "large", "xlarge"], default: "tiny"
  data active_tab, :string
  data animation, :string, default: ""
  slot tabs

  @impl true
  def update(assigns, socket) do
    active_tab = get_active_tab(assigns)
    {:ok, assign(socket, assigns) |> assign(active: active_tab)}
  end

  @impl true
  def render(assigns) do
    underlined = assigns.type == "underlined"

    active_tab = get_active_tab(assigns)

    ~F"""
    <Space direction="vertical" size={4}
      opts={"x-data": "{ activeTab: '#{active_tab}' }"}
    >
      <div id={@id} role="tablist" aria-label={@id}
      >
        <Space class="sbui-tab-bar-container" size={0}>
          <Space size={if underlined, do: 6, else: 3} class="sbui-tab-bar-inner-container">
            <Button
             :for={{tab, _index} <- Enum.with_index(@tabs)}
             click="tab_click"
             size={@size}
             type={button_type(active_tab, tab.label, underlined)}
             opts={role: "tab", "phx-value-label": tab.label}
             class={button_classes(active_tab, tab.label, underlined)}
            >{tab.label}
            </Button>
          </Space>
        </Space>
        {#if underlined}
        <Divider />
        {/if}
      </div>
      <div
        :for={{tab, index} <- Enum.with_index(@tabs)}
        :show={active_tab == tab.label}
        id={tab.label}
        role="tabpanel"
        aria-labelledby={tab.label}
        class={@animation}
      >
        <#slot name="tabs" index={index} />
      </div>
    </Space>
    """
  end

  @impl true
  def handle_event(
        "tab_click",
        %{"label" => label},
        socket
      ) do
    animation = get_animation(socket.assigns, label)

    {:noreply, assign(socket, active: label, animation: animation)}
  end

  defp get_animation(assigns, next_label) do
    active_index = Enum.find_index(assigns.tabs, &(&1.label == assigns.active))
    next_index = Enum.find_index(assigns.tabs, &(&1.label == next_label))

    cond do
      active_index < next_index -> "slide-in-right"
      active_index > next_index -> "slide-in-left"
      true -> assigns.animation
    end
  end

  defp get_active_tab(%{active: active_tab}) when not is_nil(active_tab), do: active_tab

  defp get_active_tab(%{tabs: tabs}) do
    first_tab = List.first(tabs)
    first_tab.label
  end

  defp button_classes(active_tab, active_tab, true) do
    "sbui-tab-button-underline sbui-tab-button-underline--active"
  end

  defp button_classes(_, _, true) do
    "sbui-tab-button-underline"
  end

  defp button_classes(_, _, _), do: ""

  defp button_type(active_tab, active_tab, false), do: "primary"
  defp button_type(_, _, _), do: "text"
end

defmodule SupabaseSurface.Components.Tabs.Example do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Tabs,
    height: "200px",
    title: "Tabs"

  alias SupabaseSurface.Components.Tabs
  alias SupabaseSurface.Components.Tab

  def render(assigns) do
    ~F"""
    <Tabs id="example-tabs">
      <Tab label="tab 1">Nunc pellentesque gravida ultricies. Integer non mollis lorem. Morbi vel hendrerit nibh, in egestas magna.</Tab>
      <Tab label="tab 2">Etiam varius lectus lectus, nec pharetra lacus commodo quis.</Tab>
    </Tabs>
    """
  end
end

defmodule SupabaseSurface.Components.Tabs.Underlined do
  @moduledoc """
  TODO: investigate how to correctly apply styling, currently "sbui-tab-button-underline" and
  "sbui-tab-button-underline--active" are overridden by other styles
  """
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Tabs,
    height: "200px",
    title: "Underlined"

  alias SupabaseSurface.Components.Tabs
  alias SupabaseSurface.Components.Tab

  def render(assigns) do
    ~F"""
    <Tabs id="example-tabs" type="underlined">
      <Tab label="tab 1">tab 1</Tab>
      <Tab label="tab 2">tab 2</Tab>
    </Tabs>
    """
  end
end

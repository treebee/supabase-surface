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
  use Surface.Component

  alias SupabaseSurface.Components.Button
  alias SupabaseSurface.Components.Divider
  alias SupabaseSurface.Components.Space
  alias SupabaseSurface.Components.Tab

  prop id, :string
  prop type, :string, values: ["pills", "underlined", "cards"], default: "pills"
  prop size, :string, values: ["tiny", "small", "medium", "large", "xlarge"], default: "tiny"
  data active_tab, :string
  slot tabs

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
             opts={role: "tab", "phx-value-label": tab.label, "@click": "activeTab = '#{tab.label}'; console.log('#{tab.label}')"}
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
        x-show={"activeTab == '#{tab.label}'"}
        id={tab.label}
        role="tabpanel"
        aria-labelledby={tab.label}
      >
        <#slot name="tabs" index={index} />
      </div>
    </Space>
    """
  end

  def get_active_tab(%{active: active_tab}) when not is_nil(active_tab), do: active_tab

  def get_active_tab(%{tabs: tabs}) do
    first_tab = List.first(tabs)
    first_tab.label
  end

  def button_classes(active_tab, active_tab, true) do
    "sbui-tab-button-underline sbui-tab-button-underline--active"
  end

  def button_classes(_, _, true) do
    "sbui-tab-button-underline"
  end

  def button_classes(_, _, _), do: ""

  def button_type(active_tab, active_tab, false), do: "primary"
  def button_type(_, _, _), do: "text"
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
      <Tab label="tab 1">tab 1</Tab>
      <Tab label="tab 2">tab 2</Tab>
    </Tabs>
    """
  end
end

defmodule SupabaseSurface.Components.Tabs.Underlined do
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
    <span role="button" :on-click="test-click">Click span</span>
    """
  end
end

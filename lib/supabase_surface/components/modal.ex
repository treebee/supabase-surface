defmodule SupabaseSurface.Components.Modal.Trigger do
  use Surface.Component, slot: "trigger"

  alias SupabaseSurface.Components.Button

  @doc "Name of the event to open the Modal"
  prop click, :event, default: "open"
  @doc "Label of the default Button to open the Modal"
  prop label, :string, default: "Open"

  slot default

  @impl true
  def render(assigns) do
    ~F"""
    <#slot>
      <Button click={@click}>{@label}</Button>
    </#slot>
    """
  end
end

defmodule SupabaseSurface.Components.Modal do
  use Surface.LiveComponent

  alias SupabaseSurface.Components.Button
  alias SupabaseSurface.Components.Space
  alias SupabaseSurface.Components.Typography

  @doc "The title for the Modal"
  prop title, :string

  @doc "Description for the Modal"
  prop description, :string

  @doc "The layout of the Modal"
  prop layout, :string, values: ["horizontal", "vertical"], default: "horizontal"

  @doc "Flag to hide the Modal footer"
  prop hide_footer, :boolean, default: false

  @doc "The Modal size"
  prop size, :string, values: ["tiny", "small", "medium", "large"], default: "large"

  @doc "Variant for the Modal"
  prop variant, :string, values: ["danger", "warning", "success"], default: "success"

  @doc "If the Modal is visible"
  prop visible, :boolean, default: false

  @doc "Additional CSS classes"
  prop class, :css_class, default: ""

  @doc "Additional CSS classes for the overlay"
  prop overlay_class, :css_class, default: ""

  prop footer_background, :boolean, default: false
  prop align_footer, :string, values: ["right", "left"], default: "left"

  prop cancel_text, :string, default: "Cancel"
  prop confirm_text, :string, default: "Confirm"

  @doc "Modal content"
  slot default

  @doc "Slot for the trigger element to open the Modal"
  slot trigger

  defp footer_layout(%{layout: "vertical"}), do: "center"
  defp footer_layout(%{align_footer: "left"}), do: "flex-start"
  defp footer_layout(_assigns), do: "flex-end"

  defp footer(%{hide_footer: true}), do: ""

  defp footer(assigns) do
    ~F"""
    <Space style={width: "100%", "justify-content": footer_layout(assigns)}>
      <Button type="outline" click="close">{@cancel_text}</Button>
      <Button click="confirm">{@confirm_text}</Button>
    </Space>
    """
  end

  @impl true
  def render(assigns) do
    modal_classes = ["sbui-modal", "sbui-modal--#{assigns.size}", assigns.class]
    overlay_classes = ["sbui-modal-overlay", assigns.overlay_class]
    footer_classes = ["sbui-modal-footer"]

    footer_classes =
      if assigns.footer_background do
        footer_classes ++ ["sbui-modal-footer--with-bg"]
      else
        footer_classes
      end

    container_classes = ["sbui-modal-container"]

    ~F"""
    <div :on-window-keydown="close" phx-key="Escape">
    <#slot name="trigger" />
    <div class={Enum.join(container_classes, " ")} :if={@visible}>
      <div class="sbui-modal-flex-container">
        <div class="sbui-modal-overlay-container">
          <div class={overlay_classes}></div>
          <span class="sbui-modal-div-trick"></span>
          <div class="fixed inset-0 overflow-y-auto" :on-click="close">
            <div class={modal_classes} role="dialog" aria-modal="true" aria-labelledby="modal-headline">
              <div class="sbui-modal-content">
                <Space size={5} direction={@layout} style={"align-items": (if @layout == "vertical", do: "center", else: "flex-start")}>
                  <Space size={4} direction="vertical" style={"align-items": "flex-start", "text-align": (if @layout == "vertical", do: "center", else: nil), width: "100%"}>
                    <span style={ width: "inherit" }>
                      {#if not is_nil(@title)}
                        <Typography.Title style={ "margin-bottom": ".1rem", "margin-top": "0" } level={4}>{@title}</Typography.Title>
                      {/if}
                      {#if not is_nil(@description)}
                        <Typography.Text>{@description}</Typography.Text>
                      {/if}
                    </span>
                    <#slot />
                    {#if !@hide_footer && !@footer_background}
                      {footer(assigns)}
                    {/if}
                  </Space>
                </Space>
              </div>
              {#if !@hide_footer && @footer_background}
                <div class={Enum.join(footer_classes, " ")}>
                  {footer(assigns)}
                </div>
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
    </div>
    """
  end

  def open(modal_id) do
    send_update(__MODULE__, id: modal_id, visible: true)
  end

  def close(modal_id) do
    send_update(__MODULE__, id: modal_id, visible: false)
  end

  @impl true
  def handle_event("open", _, socket) do
    {:noreply, assign(socket, visible: true)}
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, assign(socket, visible: false)}
  end
end

defmodule SupabaseSurface.Catalogue.Modal.Example do
  use Surface.Catalogue.Example,
    catalogue: SupabaseSurface.Catalogue,
    subject: SupabaseSurface.Components.Modal,
    height: "250px",
    direction: "vertical",
    title: "Modal"

  alias SupabaseSurface.Components.Divider
  alias SupabaseSurface.Components.Modal
  alias SupabaseSurface.Components.Typography

  @impl true
  def render(assigns) do
    ~F"""
    <Modal id="modal" title="My Modal" description="This is the Modal description">
      <Modal.Trigger click="open" />
      <Typography.Text>Modal content</Typography.Text>
    </Modal>
    <Divider class="my-4" />
    <Modal id="bg-modal" title="My Modal" description="This is the Modal description" footer_background>
      <Modal.Trigger click="bg-open" label="Footer Background" />
      <Typography.Text>Modal content</Typography.Text>
    </Modal>

    """
  end

  @impl true
  def handle_event("open", _, socket) do
    Modal.open("modal")
    {:noreply, socket}
  end

  @impl true
  def handle_event("bg-open", _, socket) do
    Modal.open("bg-modal")
    {:noreply, socket}
  end
end

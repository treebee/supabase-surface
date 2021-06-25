# copied and adapted from https://github.com/surface-ui/surface/blob/master/lib/surface/components/form/text_input.ex
defmodule SupabaseSurface.Components.Form.TextInput do
  @moduledoc """
  An input field that let the user enter a **single-line text**.
  Provides a wrapper for Phoenix.HTML.Form's `text_input/3` function.
  All options passed via `opts` will be sent to `text_input/3`, `value` and
  `class` can be set directly and will override anything in `opts`.
  ## Examples
  ```
  <TextInput form="user" field="name" opts={{ autofocus: "autofocus" }} />
  ```
  """

  use Surface.Components.Form.Input

  import Phoenix.HTML.Form, only: [text_input: 3]
  import Surface.Components.Utils, only: [events_to_opts: 1]
  import Surface.Components.Form.Utils

  alias Surface.Components.Form.{Label, Field}

  prop label, :string, required: true

  def render(assigns) do
    default_class = get_default_class()
    default_class = if is_nil(default_class), do: [], else: default_class
    class = default_class ++ ["sbui-input", "sbui-input--medium", "form-input"]
    helper_opts = props_to_opts(assigns)
    attr_opts = props_to_attr_opts(assigns, [:value, class: class])
    event_opts = events_to_opts(assigns)

    ~F"""
      <Field name={@name} class="sbui-formlayout sbui-formlayout--medium sbui-formlayout--responsive">
        <div class="sbui-space-row sbui-space-x-2 sbui-formlayout__label-container-horizontal">
          <Label :if={@label} class="sbui-formlayout__label">{@label}</Label>
        </div>
        <div class="sbui-formlayout__content-container-horizontal">
          <InputContext assigns={assigns} :let={form: form, field: field}>
            <div class="sbui-input-container">
            {text_input(form, field, helper_opts ++ attr_opts ++ @opts ++ event_opts)}
            </div>
          </InputContext>
        </div>
      </Field>
    """
  end
end

defmodule SupabaseSurface.Components.Utils do
  def get_style(assigns) do
    assigns.style
    |> Stream.filter(fn {_key, value} -> not is_nil(value) end)
    |> Enum.map(fn {key, value} -> "#{key}: #{value}" end)
    |> Enum.join("; ")
  end
end

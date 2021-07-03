defmodule SupabaseSurface.Components.Icons.IconGitPullRequest do
  use SupabaseSurface.Components.Icon

  @impl true
  def render(assigns) do
    icon_size = IconContainer.get_size(assigns.size)

    ~F"""
    <IconContainer assigns={assigns}>
      {Feathericons.git_pull_request(width: icon_size, height: icon_size)}
    </IconContainer>
    """
  end
end

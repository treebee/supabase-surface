defmodule SupabaseSurface.Components.Auth do
  @moduledoc """
  A Surface component that handles auth for Supabase.

  It uses a Surface hook to parse the tokens that are provided after a successful
  login in the URI fragment ({base_url}/login#access_token=user-jwt&refresh_token=user-refresh-jwt).

  The tokens are then send to an API endpoint (default: `/session`) to set them in the session.
  This endpoint has to be provided by the user.

  ## Session Setup Example

      defmodule YourSurfaceAppWeb.SessionController do
        use YourSurfaceAppWeb, :controller

        def set_session(conn, %{"access_token" => access_token, "refresh_token" => refresh_token}) do
          conn
          |> put_session(:access_token, access_token)
          |> put_session(:refresh_token, refresh_token)
          |> json("ok")
        end

      end

      # router.ex

      scope "/", YourSurfaceAppWeb do
        pipe_through(:api)

        post("/session", SessionController, :set_session)
      end

  It currently supports `magic link` and social providers:

  ## Usage Example

      <Auth redirect_url="/welcome" magic_link={{ true }} providers={{ ["google", "github"] }} />

  """
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput, Submit}
  alias SupabaseSurface.Components.Typography.Text
  alias SupabaseSurface.Components.Icons.SocialIcon

  @doc "URL to redirect to after successful login handled by this component. In case you want
  to be redirected to a different location by the provider, use `provider_redirect_url`."
  prop(redirect_url, :string, default: "/")

  @doc "URL the provider should redirect after successful authentication. The target
  location will have to handle the passed token information."
  prop(provider_redirect_url, :string)

  @doc "API endpoint for updating the session with access_token and refresh_token"
  prop(session_url, :string, default: "/session")

  @doc "Classes to apply to the component"
  prop(class, :css_class)

  @doc "If sign in via magic link should be enabled"
  prop(magic_link, :boolean, default: true)

  @doc "Providers to use for social auth"
  prop(providers, :list)

  data(user, :map, default: %{"email" => ""})
  data(msg, :string, default: nil)
  data(type, :atom, values: [:default, :success, :danger], default: :default)

  @impl true
  def render(assigns) do
    ~H"""
    <div
      :hook="SupabaseAuth"
      data-redirect-url="{{ @redirect_url }}"
      data-session-url="{{ @session_url }}"
      data-magic-link="{{ @magic_link }}"
      class={{ "text-white px-8 py-12 bg-gray-700 border border-gray-600 border-opacity-60 rounded-md", @class }}
      >
      <div :if={{ @providers }}>
        <Text class="font-semibold">Sign in with</Text>
        <div class="pt-2 pb-8">
          <span :for={{ provider <- @providers }}>
            <button
              :on-click="authorize"
              phx-value-provider={{ provider }}
              class="my-2 py-2 w-full bg-gray-600 font-semibold text-sm flex items-center justify-center rounded-md">
              <SocialIcon class="mr-2 w-4 h-4" provider={{ provider }} />Sign up with {{ provider }}
            </button>
          </span>
        </div>
      </div>
      <Form :if={{ @magic_link }} for={{ :user }} change="change" submit="submit">
        <Field name="email" class="font-semibold text-md mb-4">
          <Label>Email address</Label>
          <div class="control flex items-center mt-4">
            <TextInput
              value="{{ @user["email"] }}" opts={{ placeholder: "Your email address" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
            <div class="absolute">{{ Heroicons.Outline.mail(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
          </div>
        </Field>
        <Submit class="bg-brand-800 w-full py-2 rounded-md font-semibold text-white">Send Magic Link</Submit>
      </Form>
      <Text :if={{ @msg }} type={{ @type }} class="py-2 px-1">{{ @msg }}</Text>
    </div>
    """
  end

  @impl true
  def handle_event("change", %{"user" => %{"email" => email}}, socket) do
    {:noreply, update(socket, :user, fn user -> Map.put(user, "email", email) end)}
  end

  @impl true
  def handle_event("submit", %{"user" => %{"email" => email}}, socket) do
    socket =
      case Supabase.auth()
           |> GoTrue.send_magic_link(email) do
        :ok -> assign(socket, msg: "Check your emails for a magic link", type: :default)
        {:error, %{"code" => 422, "msg" => msg}} -> assign(socket, msg: msg, type: :danger)
        _ -> assign(socket, msg: "Something went wrong. Please try again.", type: :danger)
      end

    {:noreply, assign(socket, :user, %{"email" => ""})}
  end

  @impl true
  def handle_event("authorize", %{"provider" => provider}, socket) do
    url = provider_url(provider, redirect_to: Map.get(socket.assigns, :provider_redirect_url))
    {:noreply, redirect(socket, external: url)}
  end

  defp provider_url(provider, options) do
    redirect_to = Keyword.get(options, :redirect_to)
    base_url = Supabase.Connection.new().base_url <> "/auth/v1/authorize?provider=#{provider}"

    case redirect_to do
      nil -> base_url
      redirect_to -> base_url <> "&redirect_to=#{redirect_to}"
    end
  end
end

defmodule SupabaseSurface.Components.Auth do
  @moduledoc """
  A Surface component that handles auth for Supabase.

  It uses a Surface hook to parse the tokens that are provided after a successful
  login in the URI fragment (`{base_url}/login#access_token=user-jwt&refresh_token=user-refresh-jwt`).

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

  It currently supports **magic link** and **social providers**:

  ## Usage Example

      <Auth redirect_url="/welcome" magic_link={{ true }} providers={{ ["google", "github"] }} />

  """
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput, Submit, PasswordInput, HiddenInput}
  alias SupabaseSurface.Components.Divider
  alias SupabaseSurface.Components.Typography.{Text, Link}
  alias SupabaseSurface.Components.Icons.SocialIcon

  @default_user %{"email" => "", "password" => ""}

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
  prop(providers, :list,
    values: ["google", "github", "gitlab", "bitbucket", "twitter", "facebook"]
  )

  @doc "Enable login via email plus password"
  prop(password_login, :boolean, default: false)

  data(user, :map, default: @default_user)
  data(msg, :string, default: nil)
  data(type, :atom, values: [:default, :success, :danger], default: :default)
  data view, :string, default: "login"

  # TODO: this really needs a bunch of tests
  @impl true
  def render(assigns) do
    ~H"""
    <div
      :hook="SupabaseAuth"
      data-redirect-url="{{ @redirect_url }}"
      data-session-url="{{ @session_url }}"
      data-magic-link="{{ @magic_link }}"
      class={{ "dark flex flex-col gap-4 text-white px-8 py-12 bg-gray-700 border border-gray-600 border-opacity-60 rounded-md sbui-typography-container", @class }}
      >
      <div :if={{ @view == "login" }}>
        {{ render_social(assigns) }}
        <div :if={{ @password_login or @magic_link }}
          x-data="{
            view: {{ @magic_link }} ? 'magic' : 'password'
          }"
        >
          <Divider :if={{ uses_social_login(@providers) }} class="mb-4">or continue with</Divider>

          <!-- login via magic link -->
          <div x-show="view === 'magic'" x-cloak>
          {{ render_magic(assigns) }}
          </div>

          <!-- login via password -->
          <div x-show="view === 'password' || view === 'register'" x-cloak>
          {{ render_password(assigns) }}
          </div>

          <!-- reset password -->
          <div x-show="view === 'reset'" x-cloak>
          {{ render_reset(assigns) }}
          </div>

        </div>
      </div>
      <div :if={{ @view == "recovery" }}>
        {{ render_update_password(assigns) }}
      </div>
      <Text :if={{ @msg }} type={{ @type }} class="py-2 px-1">{{ @msg }}</Text>
    </div>
    """
  end

  defp render_social(assigns) do
    ~H"""
    <div :if={{ @providers }}>
      <Text type={{ :secondary }} class="sbui-auth-label">Sign in with</Text>
      <div class="pt-2">
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
    """
  end

  defp render_reset(assigns) do
    ~H"""
    <Form
      :if={{ @password_login }}
      for={{ :reset_user }} change="change" submit="submit">
       <div class="sbui-space-col sbui-space-y-6">
         <div class="sbui-space-col sbui-space-y-3">
      <Field name="email" class="font-semibold text-md mb-4">
        <Label>Email address</Label>
        <div class="control flex items-center mt-4">
          <TextInput
            value="{{ @user["email"] }}" opts={{ placeholder: "Your email address" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
          <div class="absolute">{{ Heroicons.Outline.mail(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
        </div>
      </Field>
      <Submit class="bg-brand-800 w-full rounded-md font-semibold text-white py-1.5 mb-2 flex items-center gap-2 justify-center">
        {{ Heroicons.Outline.inbox(class: "w-6 h-6") }}
      Send reset password instructions</Submit>
      </div>
      </div>
    </Form>
    <Link opts={{ "@click": "view = 'password'" }} class="my-8">
      Go back to sign in
    </Link>
    """
  end

  defp render_update_password(assigns) do
    ~H"""
    <Form
      for={{ :update_password }} change="change" submit="submit">
      <Field name="password" class="font-semibold text-md mb-4">
        <Label>Password</Label>
        <div class="control flex items-center mt-4">
          <PasswordInput
            value="{{ @user["password"] }}" opts={{ placeholder: "Password" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
          <div class="absolute">{{ Heroicons.Outline.key(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
        </div>
      </Field>
      <Submit class="bg-brand-800 w-full rounded-md font-semibold text-white py-1.5 my-2 flex items-center gap-2 justify-center">
        {{ Heroicons.Outline.inbox(class: "w-6 h-6")}}
        Update password
      </Submit>
    </Form>
    """
  end

  defp render_magic(assigns) do
    ~H"""
    <Form
      :if={{ @magic_link }}
      for={{ :magic_user }} change="change" submit="submit">
      <Field name="email" class="font-semibold text-md mb-4">
        <Label>Email address</Label>
        <div class="control flex items-center mt-4">
          <TextInput
            value="{{ @user["email"] }}" opts={{ placeholder: "Your email address" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
          <div class="absolute">{{ Heroicons.Outline.mail(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
        </div>
      </Field>
      <Submit class="bg-brand-800 w-full rounded-md font-semibold text-white py-1.5 my-2 flex items-center gap-2 justify-center">
        {{ Heroicons.Outline.inbox(class: "w-6 h-6")}}
        Send Magic Link
      </Submit>
    </Form>
    <Link :if={{ @password_login }} opts={{ "@click": "view = 'password'" }} class="my-8">
      Sign in with password
    </Link>
    """
  end

  defp render_password(assigns) do
    ~H"""
    <Form
      :if={{ @password_login }}
      for={{ :password_user }} as={{ :user }} change="change" submit="submit"
    >
      <Field name="email" class="font-semibold text-md mb-4">
        <Label>Email address</Label>
        <div class="control flex items-center mt-4">
          <TextInput
            value="{{ @user["email"] }}" opts={{ placeholder: "Your email address" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
          <div class="absolute">{{ Heroicons.Outline.mail(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
        </div>
      </Field>
      <Field name="password" class="font-semibold text-md mb-4">
        <Label>Password</Label>
        <div class="control flex items-center mt-4">
          <PasswordInput
            value="{{ @user["password"] }}" opts={{ placeholder: "Password" }} class="placeholder-gray-400 text-xs pl-10 py-2 bg-transparent border border-gray-400 rounded-md w-full" />
          <div class="absolute">{{ Heroicons.Outline.key(class: "w-6 h-6 ml-2 text-gray-400") }}</div>
        </div>
      </Field>
      <HiddenInput name="login_type" opts={{ "x-bind:value": "view" }} />
      <div x-show="view === 'password'" class="sbui-space-col sbui-space-y-6" x-cloak>
        <div class="sbui-space-row sbui-space-x-2 flex justify-end">
          <Link opts={{ "@click": "view = 'reset'" }}>Forgot your password?</Link>
        </div>
        <span class="sbui-btn-container sbui-btn--w-full">
         <Submit class="bg-brand-800 w-full rounded-md font-semibold text-white py-1.5 my-2 flex items-center gap-2 justify-center">
          {{ Heroicons.Outline.lock_closed(class: "w-6 h-6") }}
          Sign in</Submit>
        </span>
      </div>
      <div x-show="view === 'register'" class="sbui-space-col sbui-space-y-6" x-cloak>
        <Submit class="bg-brand-800 w-full rounded-md font-semibold text-white py-1.5 my-2 flex items-center gap-2 justify-center">
          {{ Heroicons.Outline.lock_closed(class: "w-6 h-6") }}
          Sign up
        </Submit>
      </div>
      <div x-show="view === 'password'" class="sbui-space-col sbui-space-y-2 text-center" x-cloak>
        <Link opts={{ "@click": "view = 'magic'" }} class="text-center">
          Sign in with magic link
        </Link>
        <Link opts={{ "@click": "view = 'register'" }} class="text-center">
          Don't have an account? Sign up
        </Link>
      </div>
      <div x-show="view === 'register'" class="sbui-space-col sbui-space-y-2 text-center" x-cloak>
        <Link opts={{ "@click": "view = 'password'" }} class="text-center">
          Do you have an account? Sign in
        </Link>
      </div>
    </Form>
    """
  end

  @impl true
  def handle_event("change", params, socket) do
    user_params = Map.get(params, "magic_user", Map.get(params, "password_user"))
    {:noreply, assign(socket, :user, user_params)}
  end

  @impl true
  def handle_event("submit", %{"update_password" => new_password}, socket) do
    at = socket.assigns.access_token

    socket =
      case Supabase.auth() |> GoTrue.update_user(at, new_password) do
        {:ok, _userdata} ->
          redirect(socket, to: socket.assigns.redirect_url)

        {:error, _} ->
          assign(socket, type: :danger, msg: "Something went wrong")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"reset_user" => %{"email" => email}}, socket) do
    socket =
      case Supabase.auth() |> GoTrue.recover(email) do
        :ok -> assign(socket, type: :default, msg: "Check your email for the password reset link")
        {:error, _} -> assign(socket, type: :danger, msg: "Something went wrong")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "submit",
        %{"login_type" => "password", "password_user" => credentials},
        socket
      ) do
    socket =
      case Supabase.auth() |> GoTrue.sign_in(credentials) do
        {:error, %{message: message}} ->
          assign(socket, msg: message, type: :danger)

        {:ok, %{"access_token" => _at, "refresh_token" => _rt} = credentials} ->
          push_event(socket, "sign-in", credentials)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "submit",
        %{
          "login_type" => "register",
          "password_user" => %{"email" => email, "password" => password}
        },
        socket
      ) do
    socket =
      case Supabase.auth()
           |> GoTrue.sign_up(%{email: email, password: password}) do
        {:error, %{message: "A user with this email address has already been registered"}} ->
          assign(socket, msg: "A confirmation email was sent", type: :success, user: @default_user)

        {:error, %{message: message}} ->
          assign(socket, msg: message, type: :danger)

        {:ok, _} ->
          assign(socket,
            msg: "A confirmation email was sent",
            type: :default,
            user: @default_user
          )
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "submit",
        %{"magic_user" => %{"email" => email}},
        socket
      ) do
    socket =
      case Supabase.auth() |> GoTrue.send_magic_link(email) do
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

  @impl true
  def handle_event(
        "recovery",
        %{"access_token" => access_token, "refresh_token" => refresh_token},
        socket
      ) do
    {:noreply,
     assign(socket, view: "recovery", access_token: access_token, refresh_token: refresh_token)}
  end

  defp provider_url(provider, options) do
    redirect_to = Keyword.get(options, :redirect_to)
    base_url = Supabase.Connection.new().base_url <> "/auth/v1/authorize?provider=#{provider}"

    case redirect_to do
      nil -> base_url
      redirect_to -> base_url <> "&redirect_to=#{redirect_to}"
    end
  end

  defp uses_social_login([_provider | _]), do: true
  defp uses_social_login(_), do: false
end

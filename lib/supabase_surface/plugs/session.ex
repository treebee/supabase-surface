defmodule SupabaseSurfaceWeb.Plugs.Session do
  @moduledoc """
  A plug to handle access and refresh tokens.

  In case `access_token` and `refresh_token` are not available
  in the session, it redirects to a `login_endpoint`.

  If the session already contains those tokens, it checks the
  expiration time of the access token. In case the token is already
  expired or expires in less than the (optionally provided)
  `expiry_tolerance`, it tries to refresh it.

  ## Options

    * `:login_endpoint` - a endpoint to redirect to in case of invalid tokens (default: "/login")
    * `:expiry_tolerance` - time in seconds the `access_token` still has to be valid,
      otherwise it should be refreshed (default: 60)

  ## Examples

    plug SupabaseSurface.Plugs.Session, login_endpoint: "/auth", expiry_tolerance: 120

  """
  import Plug.Conn
  import Phoenix.Controller

  def init(options \\ []) do
    %{
      login_endpoint: Keyword.get(options, :login_endpoint, "/login"),
      expiry_tolerance: Keyword.get(options, :expiry_tolerance, 60)
    }
  end

  def call(%Plug.Conn{request_path: ep} = conn, %{login_endpoint: ep}), do: conn

  def call(%Plug.Conn{} = conn, %{login_endpoint: ep, expiry_tolerance: exp_tolerance}) do
    with %{"access_token" => _at, "refresh_token" => _rt} = tokens <- get_session(conn),
         {:ok, %{"access_token" => access_token, "refresh_token" => refresh_token}} <-
           check_token_expiration(tokens, exp_tolerance),
         {:ok, user_id} <- fetch_user(access_token) do
      conn
      |> put_session(:access_token, access_token)
      |> put_session(:refresh_token, refresh_token)
      |> put_session(:user_id, user_id)
    else
      _error ->
        conn
        |> clear_session()
        |> redirect(to: ep)
        |> halt()
    end
  end

  defp check_token_expiration(
         %{"access_token" => access_token} = tokens,
         expiry_tolerance
       ) do
    {:ok, %{"exp" => exp}} = Joken.peek_claims(access_token)

    refresh_access_token(exp - System.system_time(:second), expiry_tolerance, tokens)
  end

  defp refresh_access_token(time_remaining, expiry_tolerance, tokens)
       when time_remaining < expiry_tolerance do
    Supabase.auth() |> GoTrue.refresh_access_token(tokens["refresh_token"])
  end

  defp refresh_access_token(_, _, tokens), do: {:ok, tokens}

  defp fetch_user(access_token) do
    {:ok, user} = Supabase.auth() |> GoTrue.get_user(access_token)
    {:ok, user["id"]}
  end
end

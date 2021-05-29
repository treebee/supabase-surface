# Installation and Setup

## Elixir

### Installation

In your LiveView project, add `supabase_surface` to your dependencies:

```elixir
[
    ...
    {:supabase_surface, "~> 0.1.4"},
    ...
]
```

### Configuration

One of **Supabase Surface's** dependencies is [supabase-elixir](https://github.com/treebee/supabase-elixir),
which is used to work with [Supabase](https://supabase.io).

It uses [gotrue-elixir](https://github.com/joshnuss/gotrue-elixir) for **Auth** and [postgrest-ex](https://github.com/J0/postgrest-ex) for working with the **Database**.
`supabase-elixir` ships the **Storage** functionality and provides common configuration.
For this to work, we have to add the necessary configuration options:

```elixir
config :supabase,
    base_url: "https://blalfvwaoqujxgvsitty.supabase.co",
    api_key: "<anon api key>"
```

#### Using the Auth Component

In case you intend to use the `Auth` component, you will need an api endpoint for
putting the access_token into the session.

```elixir
# router.ex
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", YourSupaAppWeb do
    pipe_through :api

    post "/session", SessionController, :set_session
  end
```

```elixir
# YourSupaAppWeb.SessionController
defmodule SupabaseSurfaceDemoWeb.SessionController do
  use SupabaseSurfaceDemoWeb, :controller

  def set_session(conn, %{"access_token" => access_token, "refresh_token" => refresh_token}) do
    conn
    |> put_session(:access_token, access_token)
    |> put_session(:refresh_token, refresh_token)
    |> json("ok")
  end
end
```

**Supabase Surface** also provides a plug, `SupabaseSurface.Plugs.Session`,
to check if there already are tokens in the session, including handling for refreshing them when necessary:

This can be added to your `:browser` pipeline in the router:

```elixir
# router.ex
pipeline :browser do
  ...
  plug SupabaseSurfaceWeb.Plugs.Session
end
```

## JavaScript

**Supabase Surface** also comes with styles and JavaScript, so you also have to
add the dependency to your `package.json`:

```javascript
"dependencies": {
  ...
  "supabase_surface": "file:../deps/supabase_surface",
  ...
}
```

### Setup

#### LiveSocket configuration

We also have to configure our `LiveSocket` to work with `Alpine.js` and include
the hooks provided by **Supabase Surface**:

```javascript
import "supabase_surface";
import { Hooks } from "supabase_surface";

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...hooks },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to);
      }
    },
  },
});
```

With that you should be good to go.

For more information check out the available guides or have a look at this
[demo](https://github.com/treebee/supabase_surface_demo).

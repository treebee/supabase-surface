# Serving Images from Supabase Storage

This is one option how images (or other static files) can be served from Supabase Storage in your
LiveView application. Might be obsolete, once the CDN integration is available.

We assume we have an application with a `Profiles` table, in which we store the users of our app.
(In addition to the `auth.users` table provided by Supabase).
In this table, users can store more information about themselves. One of the columns stores
an `avatar_url`, which can either be a full url or a `storage key`.

Full url, for example included in the metadata when logged in via Social provider:
`https://lh3.googleusercontent.com/ogw/ADGmqu8G7KLqKuy0I-ODBRu4Zd5cok_dEEE6C0Vum5PY=s32-c-mo`

Storage key:
`public/user_xy_avatar.jpg`

To show the images in our html, we can for example do:

```html
<img alt="avatar" src="{{ @profile.avatar_url }}" width="250" height="250" />
```

This will work for our full URLs, but for our Storage keys this will probably result in a `404`.
For the Storage key, our application will be queried with something like `/public/user_xy_avatar.jpg`.

## Serving Images from a Controller

So what we have to do here is to make sure that for this endpoint, the image is served. This we
can do with a simple Controller:

```elixir
defmodule YourSupaAppWeb.ImageController do
  use YourSupaAppWeb, :controller

  def public(conn, %{"filename" => filename}) do
    blob = "public/" <> user_id <> "/" <> filename

    {:ok, data} =
      conn
      |> get_session(:access_token)
      |> Supabase.storage()
      |> Supabase.Storage.from("avatars")
      |> Supabase.Storage.download(blob)

    conn
    |> put_resp_content_type(MIME.from_path(filename))
    |> put_resp_header("cache-control", "public, max-age=15552000")
    |> send_resp(200, data)
  end
end
```

We can even use the current users `access_token` from the session to verify, that she has the necessary
permissions.

Now the only thing left is adding a new endpoint to our router:

```elixir
scope "/", YourSupaWeb do
    pipe_through :browser

    get "/public/:filename", ImageController, :public
    ...
end
```

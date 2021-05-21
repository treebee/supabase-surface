# SupabaseSurface

A component library for [Supabase](supabase.io) and [Surface](https://surface-ui.org/).

> **Work in Progress**

This library can be used in a
[Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) project
that uses Surface as a component library.
It provides components

- styled like the React components of [Supabase UI](https://github.com/supabase/ui/)
- implementing functionality to handle things like [authentication](https://supabase.io/docs/guides/auth)

There are additional things, for example a [plug](https://github.com/elixir-plug/plug)
that checks the expiration time of an access_token stored in the session and
does a refresh if necessary.

## Installation

```elixir
def deps do
  [
    {:supabase_surface, github: "treebee/supabase-surface"}
  ]
end
```

You also have to add the JavaScript library as a dependency so that hooks and
other things are working:

```javascript
// package.json
"dependencies": {
    ...
    "supabase_surface": "file:../deps/supabase_surface",
    ...
}
```

And for the styles, in case of a standard phoenix live view project:

```css
/* app.scss */
@import "supabase_surface";
```

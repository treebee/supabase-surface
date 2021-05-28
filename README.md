# Supabase UI for Surface (WIP)

A component library for [Supabase](supabase.io) and [Surface](https://surface-ui.org/).

[Here](https://github.com/treebee/supabase_surface_demo) you can find a demo application
using this project.

This library can be used in a
[Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) project
that uses Surface as a component library.
It provides components

- styled like the React components of [Supabase UI](https://github.com/supabase/ui/) (it actually uses )
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

`supabase-surface` uses AlpineJS, so you will have to add

```javascript
let liveSocket = new LiveSocket("/live", Socket, {
  ...,
  dom: {
    onBeforeElUpdated(from, to){
      if(from.__x){ window.Alpine.clone(from.__x, to) }
    }
  },
})
```

to your `app.js`.

## Component Catalogue

You can also checkout the Repository and start the component catalogue to have live documentation:

    mix deps.get
    mix dev

    # or for another port

    PORT=4444 mix dev

## Credits

- **SupabaseUI**: we use a copy of CSS files and the TailwindCSS config
- **Surface**: used as the base component library; also directly copied some of the functionality
- **TailwindCSS** and **Heroicons** (with https://github.com/mveytsman/heroicons_elixir)
- **AlpineJS**: to provide better UX for components like Dropdowns
- **Phoenix/LiveView**

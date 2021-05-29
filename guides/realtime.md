# Using Supabase Realtime with Hooks

While there is no special integration for Supabase [Realtime](https://supabase.io/docs/realtime/server/about) yet,
it's pretty easy to connect to it via a custom hook.
(Which shouldn't be a surprise when using Phoenix ;))

## Example listening to `UPDATE`s

First we need a DOM element for our hook:

```html
<div
  phx-hook="Realtime"
  data-api-key="{{ Application.get_env(:supabase, :api_key) }}"
  data-url="{{ Application.get_env(:supabase, :base_url) }}"
  data-event="UPDATE"
  data-topic="realtime:public:profiles"
></div>
```

Here we called our hook `Realtime`, and added some data attributes with the
connection details and event plus topic of interest.

So we want to listen to `UPDATE`s for our `profiles` table.

Let's have a look at our hook:

```javascript
import { Socket } from "phoenix";

const Realtime = {
  mounted() {
    const wsEndpoint =
      this.el.dataset.url.replace("http", "ws") + "/realtime/v1";
    this.socket = new Socket(wsEndpoint, {
      params: { apikey: this.el.dataset.apiKey },
    });
    this.socket.connect();
    this.channel = this.socket.channel(this.el.dataset.topic);
    const event = this.el.dataset.event;
    this.channel.on(event, (payload) => this.pushEvent(event, payload));
    this.channel.join();
  },
  destroyed() {
    this.socket.disconnect();
  },
};

export default Realtime;
```

We connect to the realtime socket with the connection info passed via the data attributes.
Note that we use the `Phoenix.js` library that is already
installed as part of Phoenix, but we could also have pulled in [realtime-js](https://github.com/supabase/realtime-js)
or even [supabase-js](https://github.com/supabase/supabase-js).

When an event is sent to the channel we created, we simply forward the payload
to our LiveView.

To handle the event, we simply have to define a handler:

```elixir
@impl true
def handle_event("UPDATE", %{"record" => record, "table" => "profiles"}, socket) do
    # do something with the record
    {:noreply, socket}
end
```

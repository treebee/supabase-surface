import { Browser } from "phoenix_live_view";

const SupabaseAuth = {
  redirectUrl() {
    return this.el.dataset.redirectUrl;
  },
  sessionUrl() {
    return this.el.dataset.sessionUrl;
  },
  parseHash(hash) {
    let authParams = {};
    new URLSearchParams(hash.slice(1)).forEach(
      (value, key) => (authParams[key] = value)
    );
    return authParams;
  },
  setSession(payload, redirect = true) {
    fetch(this.sessionUrl(), {
      method: "POST",
      body: JSON.stringify(payload),
      headers: {
        "Content-Type": "application/json",
      },
    }).then((response) => {
      if (redirect) Browser.redirect(this.redirectUrl());
    });
  },
  mounted() {
    if (this.el.dataset.magicLink && window.location.hash) {
      const payload = this.parseHash(window.location.hash);
      if (payload.access_token && payload.refresh_token) {
        this.setSession(payload, payload.type != "recovery");
      }
      if (payload.type === "recovery") {
        this.pushEventTo(this.el, "recovery", payload);
      }
    }
    this.handleEvent("sign-in", (payload) => this.setSession(payload, true));
  },
};

export { SupabaseAuth };

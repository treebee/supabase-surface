ExUnit.start()

defmodule Router do
  use Phoenix.Router
end

defmodule Endpoint do
  use Phoenix.Endpoint, otp_app: :surface
  plug(Router)
end

Application.put_env(:surface, Endpoint,
  secret_key_base: "xM/64j4AU8Y5vpSaR5UDFni94h5EVbRW1njBbGUMAYd79JP2Eyitlv2keTjkQhNU",
  live_view: [
    signing_salt: "4354k5243klh2l3kh43l2k4h"
  ]
)

Endpoint.start_link()

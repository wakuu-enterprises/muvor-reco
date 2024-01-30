defmodule YourAppWeb.Router do
  use YourAppWeb, :router

  # ...

  defmodule SSOPath do
    use Phoenix.Router

    plug SSOService
  end

  scope "/sso", SSOPath do
    pipe_through [:browser]

    get "/login", SSOService, :sso_login
    get "/logout", SSOService, :slo_logout
    match "/callback", SSOService, :sso_callback, via: [:post]
    match "/logout_callback", SSOService, :slo_callback, via: [:post]
  end

  # ...
end

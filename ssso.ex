defmodule SSOService do
  use Samly

  # Replace these values with your own SAML configuration
  @idp_metadata_url "https://idp.example.com/metadata.xml"
  @sso_callback_url "http://your-app.com/sso/callback"
  @slo_callback_url "http://your-app.com/slo/callback"
  @issuer "http://your-app.com"

  def start_link(_args) do
    Samly.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # Load IdP metadata
    {:ok, config} = Samly.Metadata.load_idp_metadata(@idp_metadata_url)
    {:ok, config, periodic_sync_interval: 60_000} # Sync metadata every 60 seconds
  end

  defp sso_params(_conn, _params) do
    %{binding: :http_post}
  end

  def sso_callback(conn, %{status: :success, attrs: attrs}) do
    # Successful SSO login, handle user attributes as needed
    # Example: redirect to a home page with user information
    conn
    |> put_flash(:info, "SSO login successful!")
    |> redirect(to: "/home")
  end

  def sso_callback(conn, %{status: :failure, reason: reason}) do
    # Handle failed SSO login
    conn
    |> put_flash(:error, "SSO login failed: #{reason}")
    |> redirect(to: "/login")
  end

  defp slo_params(_conn, _params) do
    %{binding: :http_post}
  end

  def slo_callback(conn, %{status: :success}) do
    # Successful SLO logout, handle as needed
    conn
    |> put_flash(:info, "SLO logout successful!")
    |> redirect(to: "/login")
  end

  def slo_callback(conn, %{status: :failure, reason: reason}) do
    # Handle failed SLO logout
    conn
    |> put_flash(:error, "SLO logout failed: #{reason}")
    |> redirect(to: "/login")
  end
end

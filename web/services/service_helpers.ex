defmodule MediaServer.ServiceHelpers do

  def env_var(key, app \\ :media_server) do
    Application.fetch_env!(app, key)
  end
end

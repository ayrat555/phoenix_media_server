defmodule MediaServer.ServiceCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      alias MediaServer.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MediaServer.TestHelpers

      # The default endpoint for testing
      @endpoint MediaServer.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MediaServer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MediaServer.Repo, {:shared, self()})
    end

    :ok
  end
end

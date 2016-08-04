defmodule MediaServer.PageController do
  use MediaServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

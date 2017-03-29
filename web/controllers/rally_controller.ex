defmodule Rallychat.RallyController do
  use Rallychat.Web, :controller

  #auth plug probs

  def index(conn, _params) do
    render conn, "index.html"
  end
end

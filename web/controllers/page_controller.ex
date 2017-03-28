defmodule Rallychat.PageController do
    use Rallychat.Web, :controller

    def index(conn, _params) do
        render conn, "index.html"
    end
end
defmodule Rallychat.SessionController do
    use Rallychat.Web, :controller

    def new(conn, _) do
        render conn, "new.html"
    end
end
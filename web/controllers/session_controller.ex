defmodule Rallychat.SessionController do
    use Rallychat.Web, :controller

    def new(conn, _) do
        render conn, "new.html"
    end

    def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
        case Rallychat.Auth.login_by_username_pass(conn, user, pass, repo, repo: Repo) do
            {:ok, conn} ->
                conn
                |> put_flash(:info, "welcome back")
                |> render("new.html")
        end
    end

    def delete(conn, _) do
        conn
        |> Rallychat.Auth.logout()
        |> redirect(to: page_path(conn, :index))
    end
end
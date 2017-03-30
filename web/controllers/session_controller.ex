defmodule Rallychat.SessionController do
  use Rallychat.Web, :controller


  def new(conn, _) do
    render conn, "new.html"
  end


  def create(conn, %{"session" => %{"name" => name, "password" => pass}} = params) do
    case Rallychat.Auth.login_by_username_pass(conn, name, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "welcome back")
        |> redirect(to: rally_path(conn, :index))

      {:error, _, conn} ->
        conn
        |> put_flash(:error, "invalid username/password combination")
        |> render("new.html")
    end
  end


  def delete(conn, _) do
    conn
    |> Rallychat.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end

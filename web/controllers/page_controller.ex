defmodule Rallychat.PageController do
  use Rallychat.Web, :controller

  def index(conn, _params) do
   redirect(conn, to: user_path(conn, :new))
  end

  # def index(conn, params) do
  #   redirect(conn, to: "/users/new")
  # end
end

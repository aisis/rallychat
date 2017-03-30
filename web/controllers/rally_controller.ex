defmodule Rallychat.RallyController do
  use Rallychat.Web, :controller

  alias Rallychat.Message

  #auth plug probs

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, _params) do
    #no functionality yet
    changeset = Message.changeset(%Message{})
    #probs not correct
    render conn, "index.html", changeset: changeset 
  end
end

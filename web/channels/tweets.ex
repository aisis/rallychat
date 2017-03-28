defmodule Rallychat.Channels.Tweets do
  use Phoenix.Channel
  alias Rallychat.TweetStreamer

  def join("tweets", %{"track" => query}, socket) do
    spawn(fn() -> TweetStreamer.start(socket, query) end)
    {:ok, socket}
  end

end
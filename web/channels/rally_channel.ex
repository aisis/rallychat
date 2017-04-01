defmodule Rallychat.RallyChannel do
  use Rallychat.Web, :channel
  
  def join("rally:lobby", payload, socket) do
    if authorized?(payload) do
      send(self, :start_twit)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end


  def handle_in("tweet", tweet, socket) do
    payload = get_embed(tweet)

    push(socket, "tweet",  payload)
    {:noreply, socket}
  end

 
  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rally:lobby).
  def handle_out("new_msg", payload, socket) do
    
    push(socket, "new_msg", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  
  def handle_info(:start_twit, socket) do
    Process.spawn(streamer(socket), [])
    {:noreply, socket}
  end


  def handle_info(msg, socket) do
    IO.inspect(msg)
    {:noreply, socket}
  end

  def get_embed(%{id: id = load}) do
    IO.inspect load
    url = "https://publish.twitter.com/oembed"
    params = [url: "https://twitter.com/radzodevE/status/#{id}"]
    
    cred =
      Application.fetch_env!(:extwitter, :oauth)
      |> Enum.into(%{})

    {:ok, data} = ExTwitter.OAuth.request(
      :get,
      url,
      params,
      cred.consumer_key,
      cred.consumer_secret,
      cred.access_token,
      cred.access_token_secret
    )

    data |> elem(2) |> Poison.Parser.parse!()
  end

  
  def twit_test() do
    id = hd(ExTwitter.home_timeline()) |> Map.get(:id)
    url = "https://publish.twitter.com/oembed"
    params = [url: "https://twitter.com/radzodevE/status/#{id}"]
   

    cred =
      Application.fetch_env!(:extwitter, :oauth)
      |> Enum.into(%{})
        
    {:ok, data} = ExTwitter.OAuth.request(
      :get,
      url,
      params,
      cred.consumer_key,
      cred.consumer_secret,
      cred.access_token,
      cred.access_token_secret
    )
    
    payload = data |> elem(2) |> Poison.Parser.parse!()

    #payload = parsed["html"]

    Rallychat.Endpoint.broadcast!("rally:lobby", "tweet", payload)
  end

  def streamer(socket) do
    for tweet <- ExTwitter.stream_user() do
      #embed = get_embed(tweet)

    Rallychat.Endpoint.broadcast!("rally:lobby", "tweet", Map.from_struct(%ExTwitter.Model.Tweet{}))
    end
  end

end




defmodule Rallychat.RallyChannel do
  use Rallychat.Web, :channel
  
  def join("rally:lobby", payload, socket) do

    send self, :start_twit
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  
  def handle_info(:start_twit, socket) do
    IO.puts "starting streamer"
#    timeline()
    
   # Process.spawn(fn() -> streamer(self) end, [])
    {:noreply, socket}
  end


  def handle_info({"tweet", payload}, socket) do
    IO.puts "1111111111111111111111111111111111111"
    IO.inspect(payload)
    broadcast!(socket, "tweet", payload)
    {:noreply, socket}
  end


  
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  
  def streamer(pid) do

    for tweet <- ExTwitter.stream_user() do
      case tweet do
        {:friends, _} ->
          IO.inspect tweet
        %ExTwitter.Model.Tweet{id: id}  ->
          send(pid, {"tweet", id})
      end
    end
  end


  def timeline() do
    for tweet <- ExTwitter.home_timeline() do
      twit_test(tweet)
    end
  end

  
  def twit_test(tweet) do
    #id = ExTwitter.home_timeline() |> Map.get(:id)
    id = Map.get(tweet, :id)
    url = "https://publish.twitter.com/oembed"
    params = [url: "https://twitter.com/radzodevE/status/#{id}", omit_script: true]
   

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

   

    IO.inspect payload["html"]
    send self, {"tweet", payload}
  end


end

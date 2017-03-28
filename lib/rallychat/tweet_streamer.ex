defmodule Rallychat.TwitterStreamer do
    
    def start(socket, query) do
        stream = ExTwitter.stream _filter(track: query)

    for tweet <- stream do 
        Phoneix.Channel.reply(socket, "tweet:stream", tweet)
    end
end
end

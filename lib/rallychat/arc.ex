defmodule Rallychat.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition
  @versions [:original, :thumb]

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x100^ -gravity center -extent 100x100"}
  end
end
#this is to upload profile pictures
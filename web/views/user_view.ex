defmodule Rallychat.UserView do
  use Rallychat.Web, :view

  alias Rallychat.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end

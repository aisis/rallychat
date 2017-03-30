defmodule Rallychat.Message do
  use Rallychat.Web, :model

  schema "messages" do
    field :body, :string
    belongs_to :user, Rallychat.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
#    TODO validate message lenghts, etc
  end
end

defmodule Rallychat.User do
    use Rallychat.Web, :model
    use Arc.Ecto.Schema

  schema "users" do
    field :avatar, Rallychat.Avatar.Type
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end


  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(name username))
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end
  
  def changeset(user, params \\ :invalid) do
    user
    |> cast(params, [:name])
    |> cast_attachments(params, [:avatar])
    |> validate_required([:name, :avatar])
  end
end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
        _ -> changeset
    end
  end
end

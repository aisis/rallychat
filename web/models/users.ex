defmodule Rallychat.User do
  use Rallychat.Web, :model


  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end


  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 10)
    |> unique_constraint(:name)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
        _ -> changeset
    end
  end
end

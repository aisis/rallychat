defmodule Rallychat.UserController do
  use Rallychat.Web, :controller

  alias Rallychat.User

  plug :authenticate_user when action in [:index, :show]

  
  def index(conn, _params) do
    users = Repo.all(User)
    render  conn, "index.html", users: users
  end


  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end


  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end


  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rallychat.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
        
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

    end
  end
end

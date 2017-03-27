
#it was user_controller changed to user_controller.change3
defmodule Rallychat.UserController do
    use Rallychat.Web, :controller
    alias Rallychat.User

    #adding authentication
    plug :authenticate when action in [:index, :show]


def index(conn, _params)do
    users = Repo.all(Rallychat.User)
    render conn, "index.html", users: users
end

def show(conn, %{"id" => id}) do
    user = Rallychat.get(Rallychat.User, id)
    render conn, "show.html", user: user
end

def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
end

def create(conn, %{"user" => user_params}) do
   # changeset = User.changeset(%User{}, user_params) 
   changeset = User.registration_changeset(%User{}, user_params) #added registration
    case Repo.insert(changeset) do
    {:ok, user} ->
        conn
        |> Rallychat.Auth.login(user) #Added for registration
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
    {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
end

#added for authentications
defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
        conn
    else
        conn
        |> put_flash(:error, "You must be logged in to access that page")
        |> redirect(to: page_path(conn, :index))
        |> halt()
        end
    end
end
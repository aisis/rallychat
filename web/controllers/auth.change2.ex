defmodule Rallychat.Auth do
    import Plug.Conn

    def init(opts) do
        user_id = get_session(conn, :user_id)
        user    = user_id && repo.get(Rallychat, user_id)
        assign(conn, :current_user, user)
    end

    def login(conn, user) do
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renw: true)
    end

    def logout(conn) do
        configure_session(conn, drop: true)
    end
    
    import Comein.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

    def login_by_username_and_pass(conn, username, given_pass, opts) do
        repo = Keyword.fetch!(opts, :repo)
        user = repo.get_by(Rallychat.User, username: username)

        cond do
            user && checkpw(given_pass, user.password_hash) ->
                {:ok, login(conn, user)}
                user ->
                {:error, :unauthorized, conn}
                true ->
                dummy_checkpw()
                {:error, :now_found, conn}
        end
    end
    end

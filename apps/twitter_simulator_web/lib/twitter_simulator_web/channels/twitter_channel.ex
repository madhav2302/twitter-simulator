defmodule TwitterSimulatorWeb.UserChannel do
  use Phoenix.Channel
  import Logger

  def join("twitter", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("register_user", payload, socket) do
    {isSuccess, message} = TwitterSimulator.Engine.register(payload["user"], payload["password"])

    if isSuccess do
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end

  def handle_in("login_user", payload, socket) do
    {isSuccess, message} = TwitterSimulator.Engine.login(payload["user"], payload["password"])

    if isSuccess do
      TwitterSimulator.Engine.save_process_id(payload["user"], socket)
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end

  def handle_in("tweet", payload, socket) do
    username = payload["user"]
    tweet = payload["tweet"]

    {success, message} = TwitterSimulator.Engine.tweet(username, tweet)

    if success do
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end

  def handle_in("logout_user", payload, socket) do
    TwitterSimulator.Engine.logout(payload["user"])
    {:reply, {:ok, %{message: "Logout Successful"}}, socket}
  end
end

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
    Logger.info("#{inspect(socket)}")
    {isSuccess, message} = TwitterSimulator.Engine.login(payload["user"], payload["password"])

    Logger.info("Trying to login")

    if isSuccess do
      socket = assign(socket, :user, payload["user"])
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end
end

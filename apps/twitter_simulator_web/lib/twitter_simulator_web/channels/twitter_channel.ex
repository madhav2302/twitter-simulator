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

  def handle_in("follow_user", payload, socket) do
    {isSuccess, message} =
      TwitterSimulator.Engine.add_follower(payload["following"], payload["user"])

    if isSuccess do
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end

  def handle_in("query_by_hashtag", hashtag, socket) do
    {isSuccess, result} = TwitterSimulator.Engine.query_by_hashtag(hashtag)

    if isSuccess do
      {:reply, {:ok, %{result: result}}, socket}
    else
      {:reply, {:error, %{result: result}}, socket}
    end
  end

  def handle_in("query_by_mention", mention, socket) do
    {isSuccess, result} = TwitterSimulator.Engine.query_by_mention(mention)

    if isSuccess do
      {:reply, {:ok, %{result: result}}, socket}
    else
      {:reply, {:error, %{result: result}}, socket}
    end
  end

  def handle_in("retweet", payload, socket) do
    IO.puts "Into retweet"
    username = payload["user"]
    tweet_id = payload["tweet_id"]

    {success, message} = TwitterSimulator.Engine.retweet(username, tweet_id)

    if success do
      {:reply, {:ok, %{message: message}}, socket}
    else
      {:reply, {:error, %{message: message}}, socket}
    end
  end
end

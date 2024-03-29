defmodule TwitterSimulator.Engine do
  import Logger

  def register(username, password) do
    {isSuccess, message} =
      GenServer.call(:server, {:register_user, {username, password}}, :infinity)

    if(isSuccess) do
      Logger.debug("registration successful for #{username}")
    else
      Logger.debug("#{username} already registered")
    end

    {isSuccess, message}
  end

  def login(username, password) do
    if is_user_registered(username) == false do
      {false, "user not registered"}
    else
      # if(TwitterSimulator.Server.isUserLoggedIn(username) === false) do
      if(GenServer.call(:server, {:login_user, {username, password}}, :infinity)) do
        Logger.debug("login successful for #{username}")
        {true, "Login Successful"}
      else
        Logger.debug("Password incorrect")
        {false, "Password incorrect"}
      end

      # else
      #   Logger.debug("User #{username} is already logged in")
      #   {false, "User is already logged in"}
      # end
    end
  end

  def save_process_id(username, process_id) do
    TwitterSimulator.Server.save_process_id(username, process_id)
  end

  def logout(username) do
    GenServer.call(:server, {:logout, username}, :infinity)
  end

  def tweet(username, tweet) do
    {success, message} = GenServer.call(:server, {:tweet, {username, tweet, "tweet"}}, :infinity)

    if success do
      {true, message}
    else
      {false, message}
    end
  end

  defp is_user_registered(username) do
    GenServer.call(:server, {:is_user_registered, username}, :infinity)
  end

  def add_follower(username, follower) do
    GenServer.call(:server, {:add_follower, {username, follower}})
  end

  def query_by_hashtag(hashtag) do
    result = GenServer.call(:server, {:query_by_hashtag, hashtag})

    if(result == []) do
      {false, result}
    else
      {true, result}
    end
  end

  def retweet(username, tweet_id) do
    [{_tweet_id, user, tweet, _time}] = :ets.lookup(:TweetById, String.to_integer(tweet_id))

    {success, message} =
      GenServer.call(:server, {:tweet, {username, tweet, "retweet"}}, :infinity)

    if success do
      tweet = user <> ": " <> Map.get(message, :tweet)
      message = Map.put(message, :tweet, tweet)
      {true, message}
    else
      {false, message}
    end
  end

  def query_by_mention(mention) do
    result = GenServer.call(:server, {:query_by_mention, mention})

    if(result == []) do
      {false, "mention not found"}
    else
      {true, result}
    end
  end
end

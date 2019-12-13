defmodule TwitterSimulatorWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    simulate_100_users()

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      TwitterSimulatorWeb.Endpoint
      # Starts a worker by calling: TwitterSimulatorWeb.Worker.start_link(arg)
      # {TwitterSimulatorWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterSimulatorWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def simulate_100_users() do
    IO.puts("Simulate 100 users and 5 tweets for each user")

    hashtags = Enum.map(1..10, fn n -> "hashtag_#{n}" end)
    users = Enum.map(1..100, fn n -> "user_#{n}" end)

    Enum.each(users, fn u -> TwitterSimulator.Engine.register(u, u) end)

    Enum.each(users, fn u ->
      TwitterSimulator.Engine.tweet(u, random_tweet(users, hashtags))
    end)

    IO.puts("Simulated 100 users")
  end

  def random_tweet(users, hashtags) do
    random_user = Enum.random(users)
    random_hastag = Enum.random(hashtags)

    "Hey @#{random_user} , ##{random_hastag} , it's good here"
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterSimulatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

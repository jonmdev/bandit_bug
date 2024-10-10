defmodule BanditBug.Application do
    # See https://hexdocs.pm/elixir/Application.html
    # for more information on OTP Applications
    @moduledoc false

    use Application

    @impl true
    def start(_type, _args) do

        
        #================
        # START SERVERS //https://hexdocs.pm/plug/readme.html#supervised-handlers
        #================
        #httpServer = {Plug.Cowboy, plug: MyPlug, scheme: :http, port: 4000 }
        httpServer = {Bandit, plug: MyPlug, scheme: :http, port: 4000 }
        #webSocket = {Plug.Cowboy, plug: Router, scheme: :http, port: 4001}
        webSocket = {Bandit, plug: Router, scheme: :http, port: 4001}
        
        children = [
        # Starts a worker by calling: BanditBug.Worker.start_link(arg)
        # {BanditBug.Worker, arg}

            httpServer,
            webSocket
        ]

        # See https://hexdocs.pm/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: BanditBug.Supervisor]
        Supervisor.start_link(children, opts)
    end
end

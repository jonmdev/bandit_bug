
#//=====================
#//WEB SOCKET SERVER //https://hexdocs.pm/websock/0.5.3/WebSock.html
#//=====================
defmodule EchoServer do

    #//must be "WebSock compatible"
    #//https://hexdocs.pm/websock/0.5.3/WebSock.html
    
    @behaviour WebSock

    def init(options) do
        {:ok, options}
    end

    #handle_in function //WebSock will call the configured handler's WebSock.handle_in/2 callback whenever data is received from the client
    def handle_in({message_in, [opcode: :text]}, state) do

        IO.puts("RECEIVED SOMETHING");
        case message_in do
        
        "ping" ->
            IO.puts("PING IN REQUEST RECEIVED");
            {:reply, :ok, {:text, "pong"}, state}
        
        "404" ->
            {:reply, :ok, {:text, "pong"}, state}
        
        _ ->
            IO.puts("RECEIVED: " <> to_string(message_in));
            {:reply, :ok, {:text, to_string(message_in)}, state}
        end
        
    end

    #termination reasons here: https://hexdocs.pm/websock/0.5.3/WebSock.html#c:terminate/2
    def terminate(reason, state) do
        case reason do
            # The local end shut down the connection normally, by returning a {:stop, :normal, state()} tuple from one of the WebSock.handle_* callbacks
            :normal ->
                IO.puts("TERMINATED: NORMAL");
            
            #The remote end shut down the connection
            :remote ->
                IO.puts("TERMINATED: REMOTE");

            # The local server is being shut down
            :shutdown ->
                IO.puts("TERMINATED: SHUT DOWN");

            #No data has been sent or received for more than the configured timeout duration
            :timeout ->
                IO.puts("TERMINATED: TIMEOUT");

            #An error occurred. This may be the result of error handling in the local server, or the result of a WebSock.handle_* callback returning a {:stop, reason, state} tuple where reason is any value other than :normal
            {:error, reason}->
                IO.puts("TERMINATED: ERROR" <> to_string(reason));

            #suppress state not used warning 
            :never_gonna_happen ->
                IO.puts(to_string(state));

        end

    end

end

#====================
#HTTP SOCKET ROUTER
#====================
defmodule Router do
    use Plug.Router

    plug Plug.Logger
    plug :match
    plug :dispatch

    #===============================
    # instructions for html view
    #===============================
    get "/" do
        send_resp(conn, 200, """
        
        Use the JavaScript console to interact using websockets (shift F12)

        sock  = new WebSocket("ws://localhost:4001/websocket"); 
        sock.addEventListener("message", (event) => console.log(event));
        sock.addEventListener("message", (event) => { console.log("Message from server: ", event.data); }); 
        sock.addEventListener("open", () => sock.send("ping")); 
        sock.send("ping");

        """)
    end

    #===============================
    # websocket request
    #===============================
    get "/websocket" do
        conn
        |> WebSockAdapter.upgrade(EchoServer, [], timeout: 60_000)
        |> halt()
    end

    match _ do
        send_resp(conn, 404, "not found")
    end
end

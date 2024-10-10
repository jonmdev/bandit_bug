#==============================
#//PLUG MODULE FOR HTTP SERVER  https://hexdocs.pm/plug/readme.html
#==============================
defmodule MyPlug do
    import Plug.Conn
  
    #//https://hexdocs.pm/plug/Plug.Conn.html
    
    def init(options) do
        # initialize options
        options
    end

    def call(conn, _opts) do
        # test date time https://stackoverflow.com/questions/28594646/getting-the-current-date-and-or-time-in-elixir
        currentDateTime = DateTime.utc_now();
        currentDateTime = to_string(currentDateTime);

        outputOk = "Hello World: " <> currentDateTime;

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, outputOk)
    end
end

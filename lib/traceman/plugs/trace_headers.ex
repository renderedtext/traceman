defmodule Traceman.Plug.TraceHeaders do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    map = Enum.reduce(Traceman.tracing_headers, %{}, fn(header_name, result) ->
      # there could be multiple headers with the same name
      value = get_req_header(conn, header_name) |> List.first()

      Map.put(result, header_name, value)
    end)

    tracing_headers = map |> Traceman.construct

    assign conn, :tracing_headers, tracing_headers
  end
end

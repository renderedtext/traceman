defmodule Traceman.Plug.TraceHeaders do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    tracing_headers = Enum.reduce(Traceman.tracing_headers, %{}, fn(header, result) ->
      # there could be multiple headers with the same name
      http_headers = get_req_header(conn, header)

      if length(http_headers) > 0 do
        # header found, injecting it

        Map.put(result, header, hd(http_headers))
      else
        # if there is no such header, we don't inject anything into the
        # just pass it to the next iteration unchanged

        result
      end
    end)

    assign conn, :tracing_headers, tracing_headers
  end
end

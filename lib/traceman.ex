defmodule Traceman do
  require Logger

  @tracing_headers [
    "x-request-id",
    "x-b3-traceid",
    "x-b3-spanid",
    "x-b3-parentspanid",
    "x-b3-sampled",
    "x-b3-flags",
    "x-ot-span-context"
  ]

  def tracing_headers, do: @tracing_headers

  # Extracts open tracing headers from a map.
  #
  # Example:
  #
  #   headers = %{ "A" => "hello", "x-b3-traceid" => "21212121" }
  #
  #   Traceman.extract(headers) # => %{ "x-b3-traceid" => "21212121" }
  #
  def extract(map) do
    Enum.reduce(@tracing_headers, %{}, fn(header, result) ->
      trace_header = map[header]

      if trace_header do
        Map.put(result, header, trace_header)
      else
        # if there is no such header, we don't inject anything into the
        # just pass it to the next iteration unchanged

        result
      end
    end)
  end

  # Extracts open tracing headers from GRPC headers.
  #
  # Example:
  #
  #   def hello(req, stream) do
  #     tracing_headers = Traceman.from_grpc_stream(stream)
  #
  #     req = EchoServer.EchoRequest.new(message: "AAA")
  #
  #     {:ok, ch} = GRPC.Stub.connect("localhost:50051")
  #     {:ok, res} = EchoServer.Stub.echo(ch, req, metadata: tracing_headers)
  #   end
  #
  def from_grpc_stream(stream) do
    stream |> GRPC.Stream.get_headers |> extract
  end
end

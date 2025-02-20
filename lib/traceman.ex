defmodule Traceman do
  require Logger

  @tracing_headers [
    "x-request-id",
    "x-b3-traceid",
    "x-b3-spanid",
    # "x-b3-parentspanid", we will construct this based on x-b3-spanid
    "x-b3-sampled",
    "x-b3-flags",
    "x-ot-span-context"
  ]

  def tracing_headers, do: @tracing_headers

  # Extracts open tracing headers from a map, and constructs them for call to an
  # upstream service.
  #
  # Example:
  #
  #   headers = %{ "A" => "hello", "x-b3-traceid" => "21212121" }
  #
  #   Traceman.construct(headers) # => %{ "x-b3-traceid" => "21212121" }
  #
  def construct(map) do
    result = Enum.reduce(@tracing_headers, %{}, fn(header_name, result) ->
      trace_header_value = map[header_name]

      if trace_header_value do
        if header_name == "x-b3-spanid" do
          result
          |> Map.put("x-b3-spanid", trace_header_value)
          |> Map.put("x-b3-parentspanid", trace_header_value)
        else
          Map.put(result, header_name, trace_header_value)
        end
      else
        # if there is no such header, we don't inject anything into the result,
        # just pass it to the next iteration unchanged

        result
      end
    end)

    result
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
    stream |> GRPC.Stream.get_headers |> construct
  end
end

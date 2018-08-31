# Traceman

Open Tracing helper for Elixir services.

For example, in order to leverage the in depth tracing options of Istio/Jaeger,
you must send a set of headers in all service-to-service communication. Traceman
provides conveniences for this.

## Installation

Add this to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:traceman, github: "renderedtext/traceman"}
  ]
end
```

## Usage

### Extract headers from a map

``` elixir
headers = %{ "A" => "hello", "x-b3-traceid" => "21212121" }

Traceman.extract(headers) # => %{ "x-b3-traceid" => "21212121" }
```

### Extract headers from a GRPC stream

``` elixir
defmodule HelleServer do

  def hello(req, stream) do
    tracing_headers = Traceman.from_grpc_stream(stream)

    req = EchoServer.EchoRequest.new(message: "AAA")

    {:ok, ch} = GRPC.Stub.connect("localhost:50051")
    {:ok, res} = EchoServer.Stub.echo(ch, req, metadata: tracing_headers)
  end

end
```

### With Phoenix requests

Traceman comes with the `Traceman.Plug.TraceHeaders` plug. It assigns the open
tracing headers to the connection. They can be retrieved with
`conn.assigns.tracing_headers` and forwarded in other GRPC or HTTP requests the
app makes.

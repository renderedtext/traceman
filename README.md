# Traceman

Open Tracing helper for Elixir services.

## Installation

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

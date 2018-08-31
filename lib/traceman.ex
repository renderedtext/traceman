defmodule Traceman do

  @tracing_headers [
    "x-request-id",
    "x-b3-traceid",
    "x-b3-spanid",
    "x-b3-parentspanid",
    "x-b3-sampled",
    "x-b3-flags",
    "x-ot-span-context"
  ]

  def from_grpc_metadata(metadata) do
    %{} # TODO
  end

  def from_phoenix_call(call) do
    %{} # TODO
  end

end

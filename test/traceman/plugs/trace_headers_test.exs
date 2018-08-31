defmodule Traceman.Plug.TraceHeadersTest do
  use ExUnit.Case
  use Plug.Test

  describe ".call" do
    test "it assigns the headers to the connection" do
      conn =
        conn(:get, "/")
        |> put_req_header("x-request-id", "78114608-be8a-465a-b9cd-81970fb802c7")
        |> Traceman.Plug.TraceHeaders.call(%{})

      headers = conn.assigns.tracing_headers

      assert headers == %{"x-request-id" => "78114608-be8a-465a-b9cd-81970fb802c7"}
    end
  end
end

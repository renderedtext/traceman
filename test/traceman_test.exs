defmodule TracemanTest do
  use ExUnit.Case
  doctest Traceman

  describe ".construct" do
    test "removes non-trace related headers" do
      headers = %{"A" => "hello", "x-b3-traceid" => "21212121"}

      assert Traceman.construct(headers) == %{"x-b3-traceid" => "21212121"}
    end

    test "extracts all open trace headers" do
      headers = %{
        "x-request-id" => "a",
        "x-b3-traceid" => "b",
        "x-b3-spanid" => "span-id",
        "x-b3-parentspanid" => "d",
        "x-b3-sampled" => "e",
        "x-b3-flags" => "f",
        "x-ot-span-context" => "g"
      }

      assert Traceman.construct(headers) == %{
        "x-request-id" => "a",
        "x-b3-traceid" => "b",
        "x-b3-spanid" => "span-id",
        "x-b3-parentspanid" => "span-id", # copied from x-b3-spanid
        "x-b3-sampled" => "e",
        "x-b3-flags" => "f",
        "x-ot-span-context" => "g"
      }
    end
  end
end

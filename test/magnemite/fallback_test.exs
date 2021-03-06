defmodule Magnemite.FallbackTest do
  use ExUnit.Case, async: true

  alias Magnemite.Fallback

  describe "fallback_to/2" do
    test "returns the second argument when the first one is nil" do
      assert Fallback.fallback_to(nil, "fallback") == "fallback"
    end

    test "returns the first argument when it's not nil" do
      assert Fallback.fallback_to(42, "fallback") == 42
    end
  end
end

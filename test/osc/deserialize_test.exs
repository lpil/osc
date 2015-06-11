defmodule OSC.DeserializeTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Deserialize
  alias OSC.Serialize

  @float_epsilon :math.pow( 2, -24 )
  
  test ".int32 test numbers" do
    assert 1           == Deserialize.int32(<<0, 0, 0, 1>>)
    assert 2           == Deserialize.int32(<<0, 0, 0, 2>>)
    assert -2          == Deserialize.int32(<<255, 255, 255, 254>>)
    assert 2147483647  == Deserialize.int32(<<127, 255, 255, 255>>)
    assert -2147483647 == Deserialize.int32(<<128, 0, 0, 1>>)
  end

  property ".int32 serialize deserialize" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        assert x == x |> Serialize.int32 |> Deserialize.int32
      end
    end
  end


  test ".float32 test numbers" do
    pi = 3.14 # three-ish
    y = pi |> Serialize.float32 |> Deserialize.float32
    assert_in_delta pi, y, delta(pi)
  end

  property ".float32 serialize deserialize" do
    for_all x in real do
      y = x |> Serialize.float32 |> Deserialize.float32
      assert_in_delta x, y, delta(x)
    end
  end


  def delta(x) do
    abs( x * @float_epsilon )
  end
end

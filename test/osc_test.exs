defmodule OSCTest do
  use ExUnit.Case, async: false
  use ExCheck

  @float_epsilon :math.pow( 2, -24 )

  test ".string test strings" do
    assert OSC.string("Heya")    == <<72, 101, 121, 97>>
    assert OSC.string("Wassup!") == <<87, 97, 115, 115, 117, 112, 33, 0>>
    assert OSC.string("Hi")      == <<72, 105, 0, 0>>
    assert OSC.string("Hello")   == <<72, 101, 108, 108, 111, 0, 0, 0>>
  end

  property ".string binary size" do
    for_all x in list(char) do
      size = x |> to_string |> OSC.string |> byte_size
      rem( size, 4 ) == 0
    end
  end


  test ".int32 test numbers" do
    assert OSC.int32(1)           == <<0, 0, 0, 1>>
    assert OSC.int32(2)           == <<0, 0, 0, 2>>
    assert OSC.int32(-2)          == <<255, 255, 255, 254>>
    assert OSC.int32(2147483647)  == <<127, 255, 255, 255>>
    assert OSC.int32(-2147483647) == <<128, 0, 0, 1>>
  end

  test ".int32 round floats" do
    assert OSC.int32(1.0)         == <<0, 0, 0, 1>>
    assert OSC.int32(1.2)         == <<0, 0, 0, 1>>
    assert OSC.int32(1.8)         == <<0, 0, 0, 2>>
    assert OSC.int32(-2.1)        == <<255, 255, 255, 254>>
  end

  test ".in32 raises error instead of overflowing" do
    assert_raise FunctionClauseError, fn ->
      OSC.int32(23428935728753)
    end
    assert_raise FunctionClauseError, fn ->
      OSC.int32(-23428935728753)
    end
  end

  property ".int32" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        << y :: 32-big-signed-integer-unit(1) >> = OSC.int32(x)
        assert x == y
      end
    end
  end


  test ".float32 test numbers" do
    assert OSC.float32(1)             == <<63, 128, 0, 0>>
    assert OSC.float32(1.0)           == <<63, 128, 0, 0>>
    assert OSC.float32(2)             == <<64, 0, 0, 0>>
    assert OSC.float32(2.2)           == <<64, 12, 204, 205>>
    assert OSC.float32(214748364700)  == <<82, 72, 0, 0>>
    assert OSC.float32(-214748364700) == <<210, 72, 0, 0>>
  end

  property ".float32" do
    for_all x in real do
      << y :: 32-big-float-unit(1) >> = OSC.float32(x)
      delta = abs( x * @float_epsilon )
      assert_in_delta x, y, delta
    end
  end


  test ".blob test binaries" do
    assert OSC.blob(<<1>>)          == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert OSC.blob(<<1, 0, 0, 0>>) == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert OSC.blob("Hi!")          == <<0, 0, 0, 4, 72, 105, 33, 0>>
  end

  property ".blob byte_size mult of 4" do
    for_all x in binary do
      size = byte_size OSC.blob( x )
      assert rem( size, 4 ) == 0
    end
  end

  property ".blob data" do
    for_all x in binary do
      implies byte_size(x) > 0 do
        << _ :: binary-size(4), y :: binary >> = OSC.blob(x)
        assert OSC.suffix_nulls(x) == y
      end
    end
  end


  property ".suffix_nulls binary size" do
    for_all x in binary do
      size = x |> OSC.suffix_nulls |> byte_size
      rem( size, 4 ) == 0
    end
  end

end

defmodule OSCTest do
  use ExUnit.Case, async: false
  use ExCheck

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

  test ".in32 raises error instead of overflowing" do
    assert_raise FunctionClauseError, fn ->
      OSC.int32(23428935728753)
    end
    assert_raise FunctionClauseError, fn ->
      OSC.int32(-23428935728753)
    end
  end

  property ".int32 result" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        << y :: 32-big-signed-integer-unit(1) >> = OSC.int32(x)
        assert x == y
      end
    end
  end


  property ".pad_to_mult_of_4 binary size" do
    for_all x in binary do
      size = x |> OSC.string |> byte_size
      rem( size, 4 ) == 0
    end
  end

end

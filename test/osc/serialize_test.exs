defmodule OSC.SerializeTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Serialize
  alias OSC.Util

  @float_epsilon :math.pow( 2, -24 )

  test ".string test strings" do
    assert Serialize.string("Heya")    == <<72, 101, 121, 97>>
    assert Serialize.string("Wassup!") == <<87, 97, 115, 115, 117, 112, 33, 0>>
    assert Serialize.string("Hi")      == <<72, 105, 0, 0>>
    assert Serialize.string("Hello")   == <<72, 101, 108, 108, 111, 0, 0, 0>>
  end

  property ".string binary size" do
    for_all x in list(char) do
      size = x |> to_string |> Serialize.string |> byte_size
      rem( size, 4 ) == 0
    end
  end


  test ".int32 test numbers" do
    assert Serialize.int32(1)           == <<0, 0, 0, 1>>
    assert Serialize.int32(2)           == <<0, 0, 0, 2>>
    assert Serialize.int32(-2)          == <<255, 255, 255, 254>>
    assert Serialize.int32(2147483647)  == <<127, 255, 255, 255>>
    assert Serialize.int32(-2147483647) == <<128, 0, 0, 1>>
  end

  test ".int32 rounds floats" do
    assert Serialize.int32(1.0)  == <<0, 0, 0, 1>>
    assert Serialize.int32(1.2)  == <<0, 0, 0, 1>>
    assert Serialize.int32(1.8)  == <<0, 0, 0, 2>>
    assert Serialize.int32(-2.1) == <<255, 255, 255, 254>>
  end

  test ".in32 raises error instead of overflowing" do
    assert_raise FunctionClauseError, fn ->
      Serialize.int32(23428935728753)
    end
    assert_raise FunctionClauseError, fn ->
      Serialize.int32(-23428935728753)
    end
  end

  property ".int32" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        << y :: 32-big-signed-integer-unit(1) >> = Serialize.int32(x)
        assert x == y
      end
    end
  end


  test ".float32 test numbers" do
    assert Serialize.float32(1)             == <<63, 128, 0, 0>>
    assert Serialize.float32(1.0)           == <<63, 128, 0, 0>>
    assert Serialize.float32(2)             == <<64, 0, 0, 0>>
    assert Serialize.float32(2.2)           == <<64, 12, 204, 205>>
    assert Serialize.float32(214748364700)  == <<82, 72, 0, 0>>
    assert Serialize.float32(-214748364700) == <<210, 72, 0, 0>>
  end

  property ".float32" do
    for_all x in real do
      << y :: 32-big-float-unit(1) >> = Serialize.float32(x)
      delta = abs( x * @float_epsilon )
      assert_in_delta x, y, delta
    end
  end


  test ".blob test binaries" do
    assert Serialize.blob(<<1>>)          == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert Serialize.blob(<<1, 0, 0, 0>>) == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert Serialize.blob("Hi!")          == <<0, 0, 0, 4, 72, 105, 33, 0>>
  end

  property ".blob byte_size mult of 4" do
    for_all x in binary do
      size = byte_size Serialize.blob( x )
      assert rem( size, 4 ) == 0
    end
  end

  property ".blob data" do
    for_all x in binary do
      implies byte_size(x) > 0 do
        << _ :: binary-size(4), y :: binary >> = Serialize.blob(x)
        assert Util.add_null_suffix(x) == y
      end
    end
  end

  @timetag_unix File.read!( "test/data/timetag_unix.dat" )

  test ".timetag :now" do
    assert Serialize.timetag( :now ) == <<0, 0, 0, 0, 0, 0, 0, 1>>
  end
  test ".timetag :immediately" do
    assert Serialize.timetag( :immediately ) == <<0, 0, 0, 0, 0, 0, 0, 1>>
  end

  test ".timetag unix ({0, 0, 0})" do
    assert Serialize.timetag( {0, 0, 0} ) == @timetag_unix
  end

end

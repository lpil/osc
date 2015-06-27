defmodule OSC.SerializeTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Serialize, as: S
  alias OSC.Util

  @float_epsilon :math.pow( 2, -24 )

  test ".string test strings" do
    assert S.string("Heya")    == <<72, 101, 121, 97>>
    assert S.string("Wassup!") == <<87, 97, 115, 115, 117, 112, 33, 0>>
    assert S.string("Hi")      == <<72, 105, 0, 0>>
    assert S.string("Hello")   == <<72, 101, 108, 108, 111, 0, 0, 0>>
  end

  property ".string binary size" do
    for_all x in list(char) do
      size = x |> to_string |> S.string |> byte_size
      rem( size, 4 ) == 0
    end
  end


  test ".int32 test numbers" do
    assert S.int32(1)           == <<0, 0, 0, 1>>
    assert S.int32(2)           == <<0, 0, 0, 2>>
    assert S.int32(-2)          == <<255, 255, 255, 254>>
    assert S.int32(2147483647)  == <<127, 255, 255, 255>>
    assert S.int32(-2147483647) == <<128, 0, 0, 1>>
  end

  test ".int32 rounds floats" do
    assert S.int32(1.0)  == <<0, 0, 0, 1>>
    assert S.int32(1.2)  == <<0, 0, 0, 1>>
    assert S.int32(1.8)  == <<0, 0, 0, 2>>
    assert S.int32(-2.1) == <<255, 255, 255, 254>>
  end

  test ".in32 raises error instead of overflowing" do
    assert_raise FunctionClauseError, fn ->
      S.int32(23428935728753)
    end
    assert_raise FunctionClauseError, fn ->
      S.int32(-23428935728753)
    end
  end

  property ".int32" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        << y :: 32-big-signed-integer-unit(1) >> = S.int32(x)
        assert x == y
      end
    end
  end


  test ".float32 test numbers" do
    assert S.float32(1)             == <<63, 128, 0, 0>>
    assert S.float32(1.0)           == <<63, 128, 0, 0>>
    assert S.float32(2)             == <<64, 0, 0, 0>>
    assert S.float32(2.2)           == <<64, 12, 204, 205>>
    assert S.float32(214748364700)  == <<82, 72, 0, 0>>
    assert S.float32(-214748364700) == <<210, 72, 0, 0>>
  end

  property ".float32" do
    for_all x in real do
      << y :: 32-big-float-unit(1) >> = S.float32(x)
      delta = abs( x * @float_epsilon )
      assert_in_delta x, y, delta
    end
  end


  test ".blob test binaries" do
    assert S.blob(<<1>>)          == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert S.blob(<<1, 0, 0, 0>>) == <<0, 0, 0, 4, 1, 0, 0, 0>>
    assert S.blob("Hi!")          == <<0, 0, 0, 4, 72, 105, 33, 0>>
  end

  property ".blob byte_size mult of 4" do
    for_all x in binary do
      size = byte_size S.blob( x )
      assert rem( size, 4 ) == 0
    end
  end

  property ".blob data" do
    for_all x in binary do
      implies byte_size(x) > 0 do
        << _ :: binary-size(4), y :: binary >> = S.blob(x)
        assert Util.add_null_suffix(x) == y
      end
    end
  end

  @timetag_1900 File.read!( "test/data/timetag_1900.dat" )
  @timetag_unix File.read!( "test/data/timetag_unix.dat" )

  test ".timetag :now" do
    assert S.timetag( :now ) == <<0, 0, 0, 0, 0, 0, 0, 1>>
  end
  test ".timetag :immediately" do
    assert S.timetag( :immediately ) == <<0, 0, 0, 0, 0, 0, 0, 1>>
  end

  test ".timetag 1970 ({0, 0, 0})" do
    assert S.timetag( {0, 0, 0} ) == @timetag_unix
  end

  test ".timetag 1900" do
    assert S.timetag( {-2_208, -988_800, 0} ) == @timetag_1900
  end

end

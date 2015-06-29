defmodule OSC.DeserializeTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Deserialize, as: D
  alias OSC.Serialize

  @float_epsilon :math.pow( 2, -24 )

  test ".int32 test numbers" do
    assert 1           === D.int32(<<0, 0, 0, 1>>)
    assert 2           === D.int32(<<0, 0, 0, 2>>)
    assert -2          === D.int32(<<255, 255, 255, 254>>)
    assert 2147483647  === D.int32(<<127, 255, 255, 255>>)
    assert -2147483647 === D.int32(<<128, 0, 0, 1>>)
  end

  property ".int32 serialize deserialize" do
    for_all x in int do
      implies x <= 2147483647 and x >= -2147483647 do
        x === x |> Serialize.int32 |> D.int32
      end
    end
  end


  test ".float32 test numbers" do
    pi = 3.14 # three-ish
    y = pi |> Serialize.float32 |> D.float32
    assert_in_delta pi, y, delta(pi)
  end

  property ".float32 serialize deserialize" do
    for_all x in real do
      y = x |> Serialize.float32 |> D.float32
      assert_in_delta x, y, delta(x)
    end
  end


  test ".string test strings" do
    assert D.string(<<72, 101, 121, 97>>) === "Heya"
    assert D.string(<<87, 97, 115, 115, 117, 112, 33, 0>>) === "Wassup!"
    assert D.string(<<72, 105, 0, 0>>) === "Hi"
    assert D.string(<<72, 101, 108, 108, 111, 0, 0, 0>>) === "Hello"
  end

  property ".string serialize deserialize" do
    for_all x in unicode_binary do
      y = x |> Serialize.string |> D.string
      x === y
    end
  end


  @max_32bit :math.pow( 2, 32 )
  @timetag_unix File.read!( "test/data/timetag_unix.dat" )
  @timetag_1900_half_sec File.read!( "test/data/timetag_1900_half_sec.dat" )

  test ".timetag :immediately" do
    assert D.timetag(<<0, 0, 0, 0, 0, 0, 0, 1>>) === :immediately
  end

  test ".timetag 1900" do
    assert D.timetag( <<0, 0, 0, 0, 0, 0, 0, 0>> ) === {-2_208, -988_800, 0}
  end
  test ".timetag 1970" do
    assert D.timetag( @timetag_unix ) === {0, 0, 0}
  end

  test ".timetag 1900 and half sec" do
    assert D.timetag( @timetag_1900_half_sec ) === {-2_208, -988_800, 500_000}
  end

  property ".timetag serialize deserialize" do
    for_all time in {non_neg_integer, non_neg_integer, non_neg_integer} do
      {x, y, z} = time
      implies Enum.all?([x, y, z], &valid_32bit_unsigned_int(&1)) do
        time |> Serialize.timetag |> D.timetag === time
      end
    end
  end

  defp valid_32bit_unsigned_int(x) do
    x > 0 and x <= @max_32bit
  end

  defp delta(x) do
    abs( x * @float_epsilon )
  end
end

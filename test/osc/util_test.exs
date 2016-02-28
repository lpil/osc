defmodule OSC.UtilTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Util

  property ".add_null_suffix binary size" do
    for_all x in binary do
      size = x |> Util.add_null_suffix |> byte_size
      rem( size, 4 ) == 0
    end
  end


  test ".strip_null_suffix with byte size of more than 4" do
    stripped = Util.strip_null_suffix( <<1, 2, 3, 4, 5, 6, 7, 0>> )
    assert <<1, 2, 3, 4, 5, 6, 7>> == stripped
  end

  test ".strip_null_suffix with byte size of less than 4" do
    assert <<1>> == Util.strip_null_suffix( <<1, 0, 0>> )
  end

  property ".strip_null_suffix .add_null_suffix cancel" do
    for_all x in binary do
      implies doesnt_end_in_null( x ) do
        x == x |> Util.add_null_suffix |> Util.strip_null_suffix
      end
    end
  end


  defp doesnt_end_in_null(<<>>) do
    true
  end
  defp doesnt_end_in_null(bin) do
    size = byte_size( bin ) - 1
    << _ :: binary-size(size), x :: binary >> = bin
    x != <<0>>
  end
end

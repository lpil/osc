defmodule OSC.Util do
  @doc """
  Pads a binary so that the byte_size is a multiple of 4
  """
  def add_null_suffix(binary) do
    add_null_suffix( binary, byte_size(binary) )
  end
  defp add_null_suffix(binary, size) when rem(size, 4) == 1 do
    binary <> <<0, 0, 0>>
  end
  defp add_null_suffix(binary, size) when rem(size, 4) == 2 do
    binary <> <<0, 0>>
  end
  defp add_null_suffix(binary, size) when rem(size, 4) == 3 do
    binary <> <<0>>
  end
  defp add_null_suffix(binary, _) do
    binary
  end


  @doc """
  Strips trailing null bytes from a binary
  """
  def strip_null_suffix(binary) when byte_size(binary) < 4 do
    binary = add_null_suffix( binary )
    strip_null_suffix( <<>>, binary )
  end
  def strip_null_suffix(binary) do
    {start, rest} = split( binary )
    strip_null_suffix( start, rest )
  end
  defp strip_null_suffix(start, <<x, 0, 0, 0>>) do
    start <> <<x>>
  end
  defp strip_null_suffix(start, <<x, y, 0, 0>>) do
    start <> <<x, y>>
  end
  defp strip_null_suffix(start, <<x, y, z, 0>>) do
    start <> <<x, y, z>>
  end
  defp strip_null_suffix(start, rest) do
    start <> rest
  end


  defp split(bin) do
    size = byte_size( bin ) - 4
    << start :: binary-size( size ), rest :: binary >> = bin
    {start, rest}
  end
end

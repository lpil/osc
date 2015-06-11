defmodule OSC.Util do
  @doc """
  Pads a binary so that the byte_size is a multiple of 4
  """
  def suffix_nulls(binary) do
    suffix_nulls( binary, byte_size(binary) )
  end
  defp suffix_nulls(binary, size) when rem(size, 4) == 1 do
    binary <> <<0, 0, 0>>
  end
  defp suffix_nulls(binary, size) when rem(size, 4) == 2 do
    binary <> <<0, 0>>
  end
  defp suffix_nulls(binary, size) when rem(size, 4) == 3 do
    binary <> <<0>>
  end
  defp suffix_nulls(binary, _) do
    binary
  end
end

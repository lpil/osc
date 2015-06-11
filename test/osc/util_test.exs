defmodule OSC.UtilTest do
  use ExUnit.Case, async: false
  use ExCheck

  alias OSC.Util

  property ".suffix_nulls binary size" do
    for_all x in binary do
      size = x |> Util.suffix_nulls |> byte_size
      rem( size, 4 ) == 0
    end
  end
end

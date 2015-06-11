defmodule OSC.Deserialize do

  @doc """
  Takes an OSC integer and returns an integer
  """
  def int32(bin) do
    << number :: 32-big-signed-integer-unit(1) >> = bin
    number
  end

  @doc """
  Takes an OSC float and returns a float
  """
  def float32(bin) do
    << number :: 32-big-float-unit(1) >> = bin
    number
  end
end

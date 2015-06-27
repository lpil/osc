defmodule OSC.Deserialize do

  alias OSC.Util

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

  @doc """
  Takes an OSC string and returns a string
  """
  def string(bin) do
    Util.strip_null_suffix( bin )
  end


  @second_divider :math.pow( 2, 32 )
  @seconds_from_1900_to_1970 2_208_988_800

  @doc """
  Takes an OSC timetag, and retuns a time tuple, or a symbol


  The tuple will be in this format:

      {megaseconds, seconds, milliseconds, microseconds}

  When the timetag is the `immediately` timetag, `:immediately` is returned.
  """
  def timetag(<<0, 0, 0, 0, 0, 0, 0, 1>>) do
    :immediately
  end
  def timetag(bin) do
    seconds = bin |> from_timetag_float
    seconds = seconds - @seconds_from_1900_to_1970
    seconds |> to_time_tuple
  end


  defp to_time_tuple(raw_seconds) do
    seconds = rem( raw_seconds, 1_000_000 ) |> floor
    mega    = div( raw_seconds, 1_000_000 ) |> floor
    milli   = 0 # TODO
    micro   = 0 # TODO
    {mega, seconds, milli, micro}
  end

  defp floor(x) when is_integer x do
    x
  end
  defp floor(x) when is_float x do
    x |> Float.floor |> trunc
  end

  defp from_timetag_float(bin) do
    << seconds :: 64-big-unsigned-integer-unit(1) >> = bin
    round( seconds / @second_divider )
  end
end

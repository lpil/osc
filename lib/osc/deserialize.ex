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


  @max_32bit :math.pow( 2, 32 )
  @seconds_from_1900_to_1970 2_208_988_800

  @doc """
  Takes an OSC timetag, and retuns a time tuple, or a symbol


  The tuple will be in the following format, which is the same as the return
  value of `:os.timestamp`

      {megaseconds, seconds, microseconds}

  When the timetag is the `immediately` timetag, `:immediately` is returned.
  """
  def timetag(<<0, 0, 0, 0, 0, 0, 0, 1>>) do
    :immediately
  end
  def timetag(bin) do
    {seconds, fraction} = bin |> from_timetag_float
    seconds = seconds - @seconds_from_1900_to_1970
    to_time_tuple( seconds, fraction )
  end


  defp to_time_tuple(raw_seconds, fraction) do
    seconds = rem( raw_seconds, 1_000_000 )
    mega    = div( raw_seconds, 1_000_000 )
    micro   = fraction / @max_32bit * 1_000_000
    {mega, seconds, micro}
  end

  defp from_timetag_float(bin) do
    <<
      seconds  :: 32-big-unsigned-integer-unit(1),
      fraction :: 32-big-unsigned-integer-unit(1),
    >> = bin
    {seconds, fraction}
  end
end

defmodule OSC.Serialize do
  alias OSC.Util

  @doc """
  Takes a string and returns an OSC string.

  Input should only contain ASCII characters.
  """
  def string(string) do
    Util.add_null_suffix( string )
  end


  @doc """
  Takes a number and returns an OSC integer

  Values must fall between -2147483647 and 2147483647
  """
  def int32(number) when is_integer number do
    do_int32(number)
  end
  def int32(number) when is_float number do
    do_int32(round number)
  end
  defp do_int32(int) when int <= 2147483647 and int >= -2147483647 do
    << int :: 32-big-signed-integer-unit(1) >>
  end


  @doc """
  Takes a number and returns an OSC float
  """
  def float32(number) when is_number number do
    << number :: 32-big-float-unit(1) >>
  end


  @doc """
  Takes a binary and returns an OSC blob
  """
  def blob(data) when is_binary data do
    data = Util.add_null_suffix( data )
    int32( byte_size data ) <> data
  end


  # The tuple can be in these formats:

  #     {megaseconds, seconds, milliseconds}
  #     {megaseconds, seconds, milliseconds, microseconds}


  @seconds_from_1900_to_1970 2_208_988_800
  @doc """
  Takes a tuple or symbol and returns an OSC timetag

  Passing either of these symbols will create the 'immediately' timetag

      :now
      :immediately
  """
  def timetag(:now) do
    <<0, 0, 0, 0, 0, 0, 0, 1>>
  end
  def timetag(:immediately) do
    <<0, 0, 0, 0, 0, 0, 0, 1>>
  end

  # def timetag({megaseconds, seconds, milliseconds}) do
  #   timetag({megaseconds, seconds, milliseconds, 0})
  # end
  # def timetag(time = {_mega, _seconds, milli, micro}) do
  #   seconds = time |> time_to_seconds |> unix_time_to_1900_time
  #   float32(seconds) + 1
  # end

  # defp time_to_seconds({megaseconds, seconds, _, _}) do
  #   time_to_seconds({megaseconds, seconds, 0})
  # end
  # defp time_to_seconds({megaseconds, seconds, _}) do
  #   megaseconds * 1000 + seconds
  # end

  # defp unix_time_to_1900_time(seconds) do
  #   seconds + @seconds_from_1900_to_1970
  # end
end

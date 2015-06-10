defmodule OSC do
  # use Application

  # # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # # for more information on OTP Applications
  # def start(_type, _args) do
  #   import Supervisor.Spec, warn: false

  #   children = [
  #     # Define workers and child supervisors to be supervised
  #     # worker(OSC.Worker, [arg1, arg2, arg3])
  #   ]

  #   # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: OSC.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end

  @doc """
  Takes a string and returns an OSC string.
  Input should only contain ASCII characters!
  """
  def string(string) do
    suffix_nulls( string )
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
    data = suffix_nulls( data )
    int32( byte_size data ) <> data
  end


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

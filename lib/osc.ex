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
    pad_to_mult_of_4( string )
  end

  @doc """
  Takes a num and returns an OSC integer

  * 2147483647 is the largest possible value
  * 2147483647 is the smallest possible value
  """
  def int32(int) when int <= 2147483647 and int >= -2147483647 do
    << int :: 32-big-signed-integer-unit(1) >>
  end

  @doc """
  Pads a binary so that the byte_size is a multiple of 4
  """
  def pad_to_mult_of_4(binary) do
    pad_to_mult_of_4( binary, byte_size(binary) )
  end
  defp pad_to_mult_of_4(binary, size) when rem(size, 4) == 1 do
    binary <> <<0, 0, 0>>
  end
  defp pad_to_mult_of_4(binary, size) when rem(size, 4) == 2 do
    binary <> <<0, 0>>
  end
  defp pad_to_mult_of_4(binary, size) when rem(size, 4) == 3 do
    binary <> <<0>>
  end
  defp pad_to_mult_of_4(binary, _) do
    binary
  end
end

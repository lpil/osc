ExUnit.start(formatters: [ShouldI.CLIFormatter])


defmodule OSCTest.Helper do

  @doc false
  defmacro __using__(_) do
    quote do
      use ShouldI
      # use ExCheck
      import OSCTest.Matchers
    end
  end

end

defmodule OSCTest.Matchers do
  import ShouldI.Matcher

  defmatcher assert_bytesize_multiple_of_4(binary) do
    quote do
      assert rem( byte_size(unquote(binary)), 4 ) == 0
    end
  end
end

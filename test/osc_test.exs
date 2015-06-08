defmodule OSCTest do
  use ExUnit.Case, async: false
  use ExCheck

  test ".string test strings" do
    assert OSC.string("Heya")    == <<72, 101, 121, 97>>
    assert OSC.string("Wassup!") == <<87, 97, 115, 115, 117, 112, 33, 0>>
    assert OSC.string("Hi")      == <<72, 105, 0, 0>>
    assert OSC.string("Hello")   == <<72, 101, 108, 108, 111, 0, 0, 0>>
  end

  property ".string binary size" do
    for_all x in list(char) do
      size = x |> to_string |> OSC.string |> byte_size
      rem( size, 4 ) == 0
    end
  end


  property ".pad_to_mult_of_4 binary size" do
    for_all x in binary do
      size = x |> OSC.string |> byte_size
      rem( size, 4 ) == 0
    end
  end

end

defmodule OSCTest do
  use OSCTest.Helper

  with ".string" do
    should "correctly format these strings" do
      assert OSC.string("Hello") == <<72, 101, 108, 108, 111, 0, 0, 0>>
      assert OSC.string("Hi") == <<72, 105, 0, 0>>
      assert OSC.string("Wassup!") == <<87, 97, 115, 115, 117, 112, 33, 0>>
    end

    with "resulting binary bytesize" do
      "Why hello!"
      |> OSC.string |> assert_bytesize_multiple_of_4

      "Hello there!"
      |> OSC.string |> assert_bytesize_multiple_of_4

      "How are you today?"
      |> OSC.string |> assert_bytesize_multiple_of_4

      "Lovely weather we're having."
      |> OSC.string |> assert_bytesize_multiple_of_4

      "Yes, much better than last week. Hailstorms, can you believe it!?"
      |> OSC.string |> assert_bytesize_multiple_of_4

      "Yes, in June! Terrible. I was wearing shorts."
      |> OSC.string |> assert_bytesize_multiple_of_4
    end
  end

  with ".pad_to_mult_of_4 and random binaries" do
    Enum.each 1..100, fn _ -> 
      :crypto.rand_bytes( :crypto.rand_uniform(1, 20) )
      |> OSC.pad_to_mult_of_4
      |> assert_bytesize_multiple_of_4
    end
  end
end

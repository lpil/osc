OSC
===

[![Build Status](https://travis-ci.org/lpil/osc.svg?branch=master)](https://travis-ci.org/lpil/osc)

Open Sound Control for Elixir


## Notes

[Specification](http://opensoundcontrol.org/spec-1_0)


### OSC Atomic Data Types

```elixir
# int32
#   32-bit big-endian two's complement integer
<< number :: 32-big-signed-integer-unit(1) >>
```

```elixir
# float32
#   32-bit big-endian IEEE 754 floating point number
<< number :: 32-big-float-unit(1) >>
```

```elixir
# OSC-string
#   A sequence of non-null ASCII characters followed by a null, followed by 0-3
#   additional null characters to make the total number of bits a multiple of
#   32. (OSC-string examples) In this document, example OSC-strings will be
#   written without the null characters, surrounded by double quotes.
"Hello" <> <<0, 0, 0>>
<<72, 101, 108, 108, 111, 0, 0, 0>> # mulitple of 4 bytes
```

```elixir
# OSC-blob
#   An int32 size count, followed by that many 8-bit bytes of arbitrary binary
#   data, followed by 0-3 additional zero bytes to make the total number of
#   bits a multiple of 32.
```

```elixir
# OSC-timetag
#   64-bit big-endian fixed-point time tag, semantics defined below
```

## References

russellmcc/node-osc-min ->
[lib](https://github.com/russellmcc/node-osc-min/blob/master/lib/osc-utilities.coffee),
[tests](https://github.com/russellmcc/node-osc-min/blob/master/test/test-osc-utilities.coffee)


mururu/msgpack-elixir ->
[packer](https://github.com/mururu/msgpack-elixir/blob/master/lib/message_pack/packer.ex)

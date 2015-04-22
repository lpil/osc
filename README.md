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
<< number :: 32-big-signed-integer-unit(1) >>  # maybe?
```

## References

russellmcc/node-osc-min ->
[lib](https://github.com/russellmcc/node-osc-min/blob/master/lib/osc-utilities.coffee), 
[tests](https://github.com/russellmcc/node-osc-min/blob/master/test/test-osc-utilities.coffee)


mururu/msgpack-elixir ->
[packer](https://github.com/mururu/msgpack-elixir/blob/master/lib/message_pack/packer.ex)

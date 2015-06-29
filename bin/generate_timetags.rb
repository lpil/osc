#!/usr/bin/env ruby

require 'date'

def self.timetag(time)
  time, _, dir = timetag_encoding(time)
  time.pack dir
end

def self.timetag_encoding(time)
  t1, fr = (time.to_f + 2_208_988_800).divmod(1)
  t2 = (fr * (2**32)).to_i
  [[t1, t2], 't', 'N2']
end

File.write(
  'test/data/timetag_1900_half_sec.dat',
  timetag(Time.at(-2_208_988_800 + 0.5))
)
File.write 'test/data/timetag_unix.dat', timetag(Time.at 0)

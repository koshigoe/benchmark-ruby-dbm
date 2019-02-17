require 'benchmark'
require_relative '../config'

ps = ''
db = {}

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    RECORD_COUNT.times do |i|
      db[format(KEY_FORMAT, i)] = format(VALUE_FORMAT, i)
    end
    ps << `ps u --no-header #{$$}`
  end

  x.report('read') do
    ps << `ps u --no-header #{$$}`
    RECORD_COUNT.times do |i|
      db[format(KEY_FORMAT, i)]
    end
    ps << `ps u --no-header #{$$}`
  end
end

puts ''
puts ps

__END__

$ ruby write-read.rb 500_000
               user     system      total        real
write      1.281160   0.263842   1.571385 (  1.572769)
read       0.300842   0.007701   0.334503 (  0.335770)

USER       PID %CPU %MEM    VSZ      RSS TTY   STAT START   TIME COMMAND
koshigoe 11411  0.0  0.0  85904    14140 pts/1 S+   15:04   0:00 ruby write-read.rb 500_000
koshigoe 11411 81.5  4.2 1115984 1043412 pts/1 S+   15:04   0:01 ruby write-read.rb 500_000
koshigoe 11411 81.5  4.2 1115984 1043412 pts/1 S+   15:04   0:01 ruby write-read.rb 500_000
koshigoe 11411 97.0  4.3 1131096 1058724 pts/1 S+   15:04   0:01 ruby write-read.rb 500_000

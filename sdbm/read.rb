require 'benchmark'
require 'sdbm'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    SDBM.open(DB_NAME, 0444) do |db|
      RECORD_COUNT.times do |i|
        db[format(KEY_FORMAT, i)]
      end
    end
    ps << `ps u --no-header #{$$}`
  end
end

puts ''
puts ps

__END__

$ ruby read.rb 500_000
               user     system      total        real
read       1.215769   2.888625   4.127203 (  4.128331)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 29530  0.0  0.0  87984 14084 pts/1    S+   15:12   0:00 ruby read.rb 500_000
koshigoe 29530  105  0.0  91128 17504 pts/1    S+   15:12   0:04 ruby read.rb 500_000

require 'benchmark'
require 'dbm'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    DBM.open(DB_NAME, 0444, DBM::READER) do |db|
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

$ bundle exec ruby read.rb 500_000
               user     system      total        real
read       0.598023   0.646751   1.267087 (  1.270316)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 16172 26.0  0.0  98868 18520 pts/1    S+   15:24   0:00 ruby read.rb 500_000
koshigoe 16172 75.0  0.0 101112 21268 pts/1    S+   15:24   0:01 ruby read.rb 500_000

require 'benchmark'
require 'dbm'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    DBM.open(DB_NAME, 0666, DBM::NEWDB) do |db|
      RECORD_COUNT.times do |i|
        db[format(KEY_FORMAT, i)] = format(VALUE_FORMAT, i)
      end
    end
    ps << `ps u --no-header #{$$}`
  end
end

puts ''
puts ps

__END__

$ bundle exec ruby write.rb 500_000
               user     system      total        real
write     13.640456  19.278301  32.945534 ( 33.210002)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 12942  0.0  0.0 100304 18540 pts/1    S+   15:19   0:00 ruby write.rb 500_000
koshigoe 12942  100  0.0 103868 23616 pts/1    S+   15:19   0:33 ruby write.rb 500_000
$ ls -l db*
-rw-r--r-- 1 koshigoe koshigoe 774090752  2月 17 15:19 db-500000.db

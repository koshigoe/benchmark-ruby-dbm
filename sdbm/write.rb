require 'benchmark'
require 'sdbm'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    SDBM.open(DB_NAME, 0666) do |db|
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

$ ruby write.rb 500_000
               user     system      total        real
write      1.739403   5.900456   7.662513 (  7.689297)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe  4646  0.0  0.0  88104 14044 pts/1    S+   15:07   0:00 ruby write.rb 500_000
koshigoe  4646 96.7  0.0  92436 18580 pts/1    S+   15:07   0:07 ruby write.rb 500_000
$ ls -l *.{dir,pag}
-rw-r--r-- 1 koshigoe koshigoe     4194304  2月 17 15:08 db-500000.dir
-rw-r--r-- 1 koshigoe koshigoe 34356848640  2月 17 15:08 db-500000.pag

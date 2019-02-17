require 'benchmark'
require 'libcdb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    LibCDB::CDB.open(DB_NAME, 'w') do |db|
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
write      1.628379   0.509936   2.160697 (  2.248181)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 29933  0.0  0.0  98628 18532 pts/1    S+   15:26   0:00 ruby write.rb 500_000
koshigoe 29933  119  0.1 112944 33020 pts/1    S+   15:26   0:02 ruby write.rb 500_000
$ ls -l db*
-rw-r--r-- 1 koshigoe koshigoe 516002048  2月 17 15:26 db-500000

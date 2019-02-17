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
write     11.001524  22.242232  33.282200 ( 33.555130)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 23771 26.0  0.0 100724 18424 pts/1    S+   15:15   0:00 ruby write.rb 500_000
koshigoe 23771 98.5  0.0 104420 22520 pts/1    S+   15:15   0:33 ruby write.rb 500_000
$ ls -l *.{dir,pag}
-rw-r--r-- 1 koshigoe koshigoe        16  2月 17 15:15 db-500000.dir
-rw-r--r-- 1 koshigoe koshigoe 536682496  2月 17 15:16 db-500000.pag

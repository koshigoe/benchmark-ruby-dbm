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
write      6.524669  15.090120  21.641397 ( 21.922223)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe  4972  0.0  0.0  98816 18492 pts/1    S+   15:22   0:00 ruby write.rb 500_000
koshigoe  4972 99.4  0.0 102356 22544 pts/1    S+   15:22   0:21 ruby write.rb 500_000
$ ls -l *.{dir,pag}
-rw-r--r-- 1 koshigoe koshigoe       181  2月 17 15:22 db-500000.dir
-rw-r--r-- 1 koshigoe koshigoe 526291472  2月 17 15:23 db-500000.pag

require 'benchmark'
require 'kyotocabinet'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    KyotoCabinet::DB.process("#{DB_NAME}.kch") do |db|
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
write      4.819895   4.346801   9.223839 (  9.228834)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 21106  0.0  0.0 102272 16320 pts/1    S+   16:24   0:00 ruby write.rb 500_000
koshigoe 21106  102  0.0 106600 21608 pts/1    S+   16:24   0:09 ruby write.rb 500_000
$ ls -l db*
-rw-r--r-- 1 koshigoe koshigoe 522297720  2月 17 16:24 db-500000.kch

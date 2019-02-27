require 'benchmark'
require 'rocksdb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    RocksDB::DB.new(DB_NAME).tap do |db|
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
write      1.964463   0.999164   2.984530 (  2.633680)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 11712  0.0  0.1 118704 27412 pts/1    S+   20:22   0:00 ruby write.rb 500_000
koshigoe 11712  107  0.4 507468 110880 pts/1   Sl+  20:22   0:03 ruby write.rb 500_000

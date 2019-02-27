require 'benchmark'
require 'rocksdb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    RocksDB::DB.new(DB_NAME).tap do |db|
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
read       1.202893   0.122216   1.345786 (  1.374707)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 13468  0.0  0.1 118704 27536 pts/1    S+   20:22   0:00 ruby read.rb 500_000
koshigoe 13468 79.5  0.1 903080 42424 pts/1    Sl+  20:22   0:01 ruby read.rb 500_000

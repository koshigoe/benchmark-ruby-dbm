require 'benchmark'
require 'leveldb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('write') do
    ps << `ps u #{$$}`
    LevelDB::DB.new(DB_NAME).tap do |db|
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
write      2.747140   0.928489   3.727582 (  3.483772)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe  7310  0.0  0.0 102624 19492 pts/1    S+   20:16   0:00 ruby write.rb 500_000
koshigoe  7310 99.0  0.1 686936 38328 pts/1    Sl+  20:16   0:03 ruby write.rb 500_000

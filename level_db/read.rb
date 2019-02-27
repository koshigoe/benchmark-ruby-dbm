require 'benchmark'
require 'leveldb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    LevelDB::DB.new(DB_NAME).tap do |db|
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
read       0.838396   0.015610   0.874464 (  0.908526)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 11814  0.0  0.0 102624 19508 pts/1    S+   20:17   0:00 ruby read.rb 500_000
koshigoe 11814  112  2.1 605196 519144 pts/1   S+   20:17   0:01 ruby read.rb 500_000

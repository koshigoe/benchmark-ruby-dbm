require 'benchmark'
require 'libcdb'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    LibCDB::CDB.open(DB_NAME, 'r') do |db|
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
read       0.443600   0.044133   0.512208 (  0.514831)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 13464  0.0  0.0  98700 18552 pts/1    S+   15:27   0:00 ruby read.rb 500_000
koshigoe 13464 75.0  0.1 105208 25556 pts/1    S+   15:27   0:00 ruby read.rb 500_000

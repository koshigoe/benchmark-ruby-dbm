require 'benchmark'
require 'dbm'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    DBM.open(DB_NAME, 0444, DBM::READER) do |db|
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
read       0.821140   0.675800   1.521430 (  1.522672)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 23727  0.0  0.0 100304 18736 pts/1    S+   15:20   0:00 ruby read.rb 500_000
koshigoe 23727 87.0  0.0 102812 22688 pts/1    S+   15:20   0:01 ruby read.rb 500_000

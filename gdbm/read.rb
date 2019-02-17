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
read       0.802744   0.031668   0.859623 (  0.860940)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe  3411  0.0  0.0 100724 18456 pts/1    S+   15:17   0:00 ruby read.rb 500_000
koshigoe  3411  111  0.0 103496 21632 pts/1    S+   15:17   0:01 ruby read.rb 500_000

require 'benchmark'
require 'kyotocabinet'
require_relative '../config'

ps = ''

Benchmark.bm(8) do |x|
  x.report('read') do
    ps << `ps u #{$$}`
    KyotoCabinet::DB.process("#{DB_NAME}.kch") do |db|
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
read       0.607743   0.521693   1.152923 (  1.154338)

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
koshigoe 31734  0.0  0.0 102276 16348 pts/1    S+   16:26   0:00 ruby read.rb 500_000
koshigoe 31734  122  0.0 105408 20364 pts/1    S+   16:26   0:01 ruby read.rb 500_000

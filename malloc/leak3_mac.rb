require 'fiddle'
require 'objspace'

def usage (str)
  rss = `ps -p #{Process.pid} -o rss -h | tail +2`.strip.to_i * 1024
  puts "#{str} RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def leak_memory
  pointers = []
  100_000.times do
    i = Fiddle.malloc(1024) #bytes
    pointers << i
  end
  50_000.times do
    Fiddle.free(pointers.pop)
  end
end

# leak_memory 0:  RSS: 22716KB // ObjectSpace size 1502KB
usage("leak_memory 0: ")

# leak_memory 70:  RSS: 3614480KB // ObjectSpace size 2352KB
100.times do |idx|
    leak_memory
    usage("leak_memory #{idx+1}: ")
end

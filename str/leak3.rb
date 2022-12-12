require 'objspace'

def usage (str)
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "#{str} RSS: #{rss / 1024}KB"
end

def leak_memory
  pointers = []
  100_000.times do
    i = "a"*10240 #bytes
    pointers << i
  end
  50_000.times do
    pointers.pop
  end
end

# leak_memory 0:  RSS: 22716KB // ObjectSpace size 1502KB
usage("leak_memory 0: ")

# leak_memory 70:  RSS: 3614480KB // ObjectSpace size 2352KB
100.times do |idx|
    leak_memory
    usage("leak_memory #{idx+1}: ")
end

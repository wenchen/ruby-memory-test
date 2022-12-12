require 'objspace'

def usage (str)
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "#{str} RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def leak_memory
  pointers = []
  100_000.times do
    i = "a"*10240 #bytes
    pointers << i
  end
  100_000.times do
    pointers.pop
  end
end

# leak_memory 0:  RSS: 22656KB // ObjectSpace size 1501KB
usage("leak_memory 0: ")

# leak_memory 100:  RSS: 110456KB // ObjectSpace size 1377KB
100.times do |idx|
    leak_memory
    usage("leak_memory #{idx+1}: ")
end

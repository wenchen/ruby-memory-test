require 'fiddle'
require 'objspace'

def usage
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def create_object_remove
  pointers = []
  100.times do |idx|
    i = Fiddle.malloc(1024) #bytes
    pointers << i
    puts "#{idx+1} objects in array. Array size #{ObjectSpace.memsize_of(pointers)}B.)"
  end
  100.times do |idx|
    Fiddle.free(pointers.pop)
    puts "#{100-idx-1} objects in array. Array size #{ObjectSpace.memsize_of(pointers)}B.)"
  end
end

usage
# RSS: 22796KB // ObjectSpace size 1492KB

puts "Start create_object_remove"
create_object_remove

usage
# RSS: 22796KB // ObjectSpace size 1523KB
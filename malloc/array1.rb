require 'fiddle'
require 'objspace'

def usage
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def create_object
  pointers = []
  100.times do |idx|
    i = Fiddle.malloc(1024) #bytes
    pointers << i
    puts "#{idx+1} objects in array. Array size #{ObjectSpace.memsize_of(pointers)}B.)"
  end
end

usage
# RSS: 22796KB // ObjectSpace size 1492KB

puts "Start create_object"
create_object

usage
# RSS: 22796KB // ObjectSpace size 1523KB
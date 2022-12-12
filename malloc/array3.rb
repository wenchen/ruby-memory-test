require 'fiddle'
require 'objspace'

def usage
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def gc_stat
  puts "GC count: #{GC.stat[:count]} // minor: #{GC.stat[:minor_gc_count]} // major: #{GC.stat[:major_gc_count]}"
end

def create_object_remove_compact
  pointers = []
  100.times do |idx|
    i = Fiddle.malloc(1024) #bytes
    pointers << i
    puts "#{idx+1} objects in array. Array size #{ObjectSpace.memsize_of(pointers)}B.)"
  end
  100.times do |idx|
    Fiddle.free(pointers.pop)
    pointers = pointers.compact
    puts "#{100-idx-1} objects in array. Array size #{ObjectSpace.memsize_of(pointers)}B.)"
  end
end

usage
# RSS: 22796KB // ObjectSpace size 1492KB

puts "Start create_object_remove_compact"
create_object_remove_compact

usage
# RSS: 22796KB // ObjectSpace size 1523KB

gc_stat
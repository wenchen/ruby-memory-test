require 'objspace'

def usage
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def gc_stat
  puts "GC count: #{GC.stat[:count]} // minor: #{GC.stat[:minor_gc_count]} // major: #{GC.stat[:major_gc_count]}"
end

def leak_memory
  pointers = []
  100_000.times do
    i = "a"*1024 #bytes
    pointers << i
  end

  puts "(After 100,000 1k object created in leak_memore. // pointers size #{ObjectSpace.memsize_of(pointers) / 1024}KB.)"
  usage

  50_000.times do
    pointers.pop
  end

  puts "(At the end of leak_memory, 50,000 objects is freed. // pointers size #{ObjectSpace.memsize_of(pointers) / 1024}KB.)"
end

usage
# RSS: 22908KB // ObjectSpace size 1500KB

gc_stat

puts "Start leak_memory"
leak_memory

usage
# RSS: 95460KB // ObjectSpace size 2352KB

puts "Force Garbage Collection"
GC.start

usage
# RSS: 94732KB // ObjectSpace size 1355KB

gc_stat

require 'fiddle'
require 'objspace'
require 'memory_profiler'

def leak_memory
  pointers = []
  100_000.times do
    i = Fiddle.malloc(1024) #bytes
    pointers << i
  end

  puts "(After 100,000 1k object created in leak_memore. // pointers size #{ObjectSpace.memsize_of(pointers) / 1024}KB.)"
  usage

  50_000.times do
    Fiddle.free(pointers.pop)
  end

  puts "(At the end of leak_memory, 50,000 objects is freed. // pointers size #{ObjectSpace.memsize_of(pointers) / 1024}KB.)"
end

puts "Start leak_memory"
report = MemoryProfiler.report do
    # run your code here
    50.times do |idx|
        leak_memory
    end
end

report.pretty_print
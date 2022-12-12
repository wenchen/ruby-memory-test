require 'fiddle'
require 'objspace'
require 'mwrap'

def usage
  rss = `ps -p #{Process.pid} -o rss -h`.strip.to_i * 1024
  puts "RSS: #{rss / 1024}KB // ObjectSpace size #{ObjectSpace.memsize_of_all / 1024}KB"
end

def leak_memory
  pointers = []
  100_000.times do
    i = Fiddle.malloc(1024)
    pointers << i
  end

  50_000.times do
    Fiddle.free(pointers.pop)
  end
end

def report_leaks
    results = []
    Mwrap.each do |location, total, allocations, frees, age_total, max_lifespan|
      results << [location, ((total / allocations.to_f) * (allocations - frees)), allocations, frees]
    end
    results.sort! do |(_, growth_a), (_, growth_b)|
      growth_b <=> growth_a
    end
  
    results[0..20].each do |location, growth, allocations, frees|
      next if growth == 0
      puts "#{location} growth: #{growth.to_i} allocs/frees (#{allocations}/#{frees})"
    end
end

GC.start
Mwrap.clear

leak_memory

GC.start

# Don't track allocations for this block
Mwrap.quiet do
  report_leaks
end

Mwrap.dump
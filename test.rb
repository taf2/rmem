$:.unshift File.join(File.dirname(__FILE__), 'ext' )
require 'rmem'

bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)
t = Time.now
N = 10000
N.times do
  bytes = RMem::Report.memory
end
puts "#{N} Iterations took: #{Time.now - t} seconds"
bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)

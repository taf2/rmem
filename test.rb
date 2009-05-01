$:.unshift File.join(File.dirname(__FILE__), 'ext' )
require 'rmem'
t = Time.now

bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)
N = 10000
N.times do
  bytes = RMem::Report.memory
end
bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)
N.times do
  bytes = RMem::Report.memory
end
bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)
puts "#{2*N + 2} Iterations took: #{Time.now - t} seconds"

require 'rmem'

bytes = RMem::Report.memory
puts format("resources: %d bytes, %.2f kbytes, and %.4f MB", bytes, bytes/1024.0, bytes/1024.0/1024.0)

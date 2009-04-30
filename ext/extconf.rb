require 'mkmf'

dir_config('rmem')
checking_for '/proc file system' do
  $defs.push( "-D HAVE_PROC" ) if File.exist?('/proc')
end
have_header('libproc.h')
have_header('windows.h')
have_header('psapi.h')
have_library('psapi')

create_header('rmem_config.h')
create_makefile('rmem')

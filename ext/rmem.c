#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rmem_config.h"
#if HAVE_LIBPROC_H
// see: http://stackoverflow.com/questions/220323/determine-process-info-programmatically-in-darwin-osx
#  include <unistd.h>
#  include <libproc.h>
#elif HAVE_PROC
// see: http://www.linuxforums.org/forum/linux-programming-scripting/11703-c-function-returns-cpu-memory-usage.html
#  include <unistd.h>
#elif HAVE_WINDOWS_H
#  include <windows.h>
#  include <psapi.h>
#else
  #error "No /proc or libproc.h"
#endif

#include <ruby.h>

static int report_memory_usage(unsigned long *size)
{
  unsigned long pid = getpid();
#ifdef HAVE_PROC
  char buf[30];
  snprintf(buf, 30, "/proc/%lu/statm", pid);
  FILE* pf = fopen(buf, "r");
  if (pf) {
    int r = fscanf(pf, "%lu", size);
    fclose(pf);
    return (r == 1) ? 0 : 1;
  }
  return 1;
#endif

#ifdef HAVE_LIBPROC_H
  struct proc_taskinfo pt;
  int ret = proc_pidinfo(pid, PROC_PIDTASKINFO, 0, &pt, sizeof(pt));
  if( ret <= 0 ) {
    return 1;
  }
  *size = pt.pti_resident_size;
  return 0;

#endif
#ifdef HAVE_WINDOWS_H
   HANDLE hProcess;
   PROCESS_MEMORY_COUNTERS pmc;

   hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, GetCurrentProcessId() );
   if (NULL == hProcess)
     return 1;
   if ( GetProcessMemoryInfo( hProcess, &pmc, sizeof(pmc)) ) {
     *size = pmc.PagefileUsage;
   }

   CloseHandle( hProcess );
   return 0;
#endif
}

static VALUE rb_rmem;
static VALUE rb_rmem_report;

static VALUE ruby_memory_report(VALUE self)
{
  unsigned long bytes;
  if( report_memory_usage(&bytes) ) {
    rb_raise(rb_eRuntimeError, "Error detecting runtime memory usage");
  }
  return rb_int_new(bytes);
}

void Init_rmem()
{
  rb_rmem = rb_define_module("RMem");
  rb_rmem_report = rb_define_class_under( rb_rmem, "Report", rb_cObject );
  rb_define_singleton_method(rb_rmem_report, "memory", ruby_memory_report, 0);
}


#ifdef TEST_ENABLED

int main( int argc, char **argv )
{
  char buffer[1024];
  unsigned long memory_usage;

  memset(buffer,0,sizeof(buffer));

  report_memory_usage(&memory_usage);

  printf("mem: %lu bytes\n", memory_usage);
  return 0;
}

#endif

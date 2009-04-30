
require 'rake/clean'
CURRENT_VERSION = "1.0.0"
RMEM_SO = "ext/rmem.#{Config::MAKEFILE_CONFIG['DLEXT']}"
# Make tasks -----------------------------------------------------
MAKECMD = ENV['MAKE_CMD'] || 'make'
MAKEOPTS = ENV['MAKE_OPTS'] || ''
CLEAN.include '**/*.o'
CLEAN.include "**/*.#{Config::MAKEFILE_CONFIG['DLEXT']}"
CLOBBER.include '**/*.log'
CLOBBER.include '**/Makefile'
CLOBBER.include '**/extconf.h'
CLOBBER.include '**/rmem_config.h'

file 'ext/Makefile' => 'ext/extconf.rb' do
  Dir.chdir('ext') do
    ruby "extconf.rb #{ENV['EXTCONF_OPTS']}"
  end
end

def make(target = '')
  Dir.chdir('ext') do 
    pid = system("#{MAKECMD} #{MAKEOPTS} #{target}")
    $?.exitstatus
  end    
end

# Let make handle dependencies between c/o/so - we'll just run it. 
file RMEM_SO => (['ext/Makefile'] + Dir['ext/*.c'] + Dir['ext/*.h']) do
  m = make
  fail "Make failed (status #{m})" unless m == 0
end

desc "Compile the shared object"
task :compile => [RMEM_SO]

task :default => :compile

desc 'Generate gem specification'
task :gemspec => :clobber do
  require 'erb'
  tspec = ERB.new(File.read(File.join(File.dirname(__FILE__),'ext','rmem.gemspec.erb')))
  File.open(File.join(File.dirname(__FILE__),'rmem.gemspec'),'wb') do|f|
    f << tspec.result
  end
end

if ! defined?(Gem)
  warn "Package Target requires RubyGEMs"
else
  desc 'Build gem'
  task :package => :gemspec do
    require 'rubygems/specification'
    spec_source = File.read File.join(File.dirname(__FILE__),'rmem.gemspec')
    spec = nil
    # see: http://gist.github.com/16215
    Thread.new { spec = eval("$SAFE = 3\n#{spec_source}") }.join
    spec.validate
    Gem::Builder.new(spec).build
  end
end

Gem::Specification.new do |s|
  s.name    = "rmem"
  s.authors = ["Todd A. Fisher"]
  s.version = '1.0.0'
  s.date    = '2009-04-30'
  s.description = %q{Measure approximate process memory}
  s.email   = 'todd.fisher@gmail.com'
  s.extra_rdoc_files = ['LICENSE', 'README']
  
  s.files = ["LICENSE", "README", "Rakefile", "doc.rb", "ext/extconf.rb", "ext/rmem.c"]
  #### Load-time details
  s.require_paths = ['ext']
  s.rubyforge_project = 'rmem'
  s.summary = %q{Ruby Memory Measurebindings}
  s.test_files = []
  s.extensions << 'ext/extconf.rb'

  #### Documentation and testing.
  s.has_rdoc = true
  s.homepage = 'http://rmem.rubyforge.org/'
  s.rdoc_options = ['--main', 'README']

  s.platform = Gem::Platform::RUBY

end

Gem::Specification.new do |s|
  s.name        = "hotchkiss"
  s.version     = "0.0.2"
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Ruby web framework"
  s.description = "Ruby web framework"
  s.authors     = ["Thibaut Deloffre"]
  s.email       = 'tib@rocknroot.org'
  s.files       = `git ls-files lib/`.split
  s.executables = ["hk"]
  s.add_dependency "bundler"
  s.add_dependency "rake"
  s.add_dependency "thor"
  s.add_dependency "rack"
  s.add_dependency "tilt"
  s.add_dependency "sequel"
  s.extra_rdoc_files = ["LICENSE.txt"]
  s.homepage    = 'https://github.com/RocknRoot/Hotchkiss'
  s.licenses    = ["BSD"]
end

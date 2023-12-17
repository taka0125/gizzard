
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gizzard/version"

Gem::Specification.new do |spec|
  spec.name          = "gizzard"
  spec.version       = Gizzard::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = %q{Often use snippet for ActiveRecord.}
  spec.description   = %q{Often use snippet for ActiveRecord.}
  spec.homepage      = "https://github.com/taka0125/gizzard"

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*', 'exe/**/*', 'sig/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.2"
  spec.add_dependency "activesupport", ">= 5.2"

  spec.add_development_dependency "ridgepole"
  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "psych", "~> 3.1"
  spec.add_development_dependency "standalone_activerecord_boot_loader", ">= 0.3"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "typeprof"
  spec.add_development_dependency "steep"
end

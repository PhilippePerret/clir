require_relative 'lib/clir/version'

Gem::Specification.new do |s|
  s.name          = "clir"
  s.version       = Clir::VERSION
  s.authors       = ["Philippe Perret"]
  s.email         = ["philippe.perret@yahoo.fr"]

  s.summary       = %q{Command Line Interface for Ruby applications}
  s.description   = %q{Command Line Interface for Ruby applications}
  s.homepage      = "https://github.com/PhilippePerret/clir"
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # --- Development dependencies ---

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-color'

  # --- Dependencies ---

  s.add_dependency "json"
  s.add_dependency "tty-prompt"


  s.metadata["allowed_push_host"] = "https://github.com/PhilippePerret/clir"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/PhilippePerret/clir"
  s.metadata["changelog_uri"] = "https://github.com/PhilippePerret/clir/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
end

# frozen_string_literal: true

require_relative "lib/cidb/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.name     = "cidb"
  spec.version  = Cidb::VERSION
  spec.authors  = ["markpitchless"]
  spec.email    = ["markpitchless@gmail.com"]

  spec.summary     = "CIDB - Contiunous Investgation DataBase - Stay ontop of your Continuous Integration."
  spec.description = "Collects data on builds and stores it in a database for analysis."
  spec.homepage    = "https://github.com/markpitchless/cidb"
  spec.license     = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/markpitchless/cidb"
  spec.metadata["changelog_uri"]   = "https://github.com/markpitchless/cidb/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "pearly/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "pearly"
  spec.version     = Pearly::VERSION
  spec.authors     = ["daniel-bryant"]
  spec.email       = ["bryant.daniel.j@gmail.com"]
  spec.homepage    = "https://github.com/daniel-bryant/pearly"
  spec.summary     = "Lightweight OAuth 2.0 plugin for Rails"
  spec.description = "Lightweight OAuth 2.0 plugin for Rails"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0", ">= 6.0.3.2"
  spec.add_dependency "jwt", "~> 2.2", ">= 2.2.1"

  spec.add_development_dependency "sqlite3"
end

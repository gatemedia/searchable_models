$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "searchable_models/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "searchable_models"
  s.version     = SearchableModels::VERSION
  s.authors     = ["David Fernandez"]
  s.email       = ["david.fernandez@gatemedia.ch"]
  s.homepage    = "https://github.com/gatemedia/searchable_models"
  s.summary     = "SearchableModels provides several helpers to build the search function on ActiveRecord models"
  s.description = "SearchableModels provides helpers to facilitate the build of the search function on a ActiveRecord model. This search can be done on several fields with different configurations: exact match, fuzzy, etc."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "minitest-reporters", "~> 1.0"
  s.add_development_dependency "simplecov", "~> 0.8"
  s.add_development_dependency "acts-as-taggable-on", "~> 3.3"
  s.add_development_dependency "globalize", "~> 4.0"
end

Gem.loaded_specs["searchable_models"].dependencies.select { |d| d.type == :runtime }.each do |d|
  require d.name
end

require "searchable_models/searchable"

module SearchableModels
end

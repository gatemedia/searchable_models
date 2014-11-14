# This module adds a scope #search which accepts a hash.
# This scope will query the fields to get a match. For queries on string fields,
# there is an option to do a "fuzzy" search (searching "bar" will match
# "foobarish")
#
# Examples
#
# class Car < ActiveRecord::Base
#
#   # calling search with :query => "bar", will fuzzy search on name and
#   # description
#   search_on :name, :mode => :fuzzy, :param => :query
#   search_on :description, :mode => :fuzzy, :param => :query
#
#   # exact matching on any field
#   search_on :number_of_doors
#
#   # supports acts_as_taggable_on
#   # eg search(:tags => %w(tag1 tag2)) # AND combination
#   #    search(:tags => %w(tag1 tag2), :tags_combination => "OR") # OR combination
#   search_on :tags
#
#   # supports globalize 3
#   translates :model_name
#   search_on :model_name, :mode => :fuzzy, :param :query
#
#   # support has_many ids
#   has_many :drivers
#   search_on :drivers_ids # search(:driver_ids => [23, 24, 27])
#
#   # support has_many ids, through
#   has_many :doors # class Door < ActiveRecord::Base; has_many :components; end
#   search_on :component_id, :through => doors
#
#   # support deep through
#   has_many :pieces
#   search :provider_id, :through => { :doors => :components }
#
#   # support scopes
#   scope :for_date, ->(date) { where(import_date => date)}
#   search_on :date, :mode => :scope, :scope => :for_date
#
#   # support enums
#   enum kind => [:van, :sedan]
#   search_on :kind, :mode => :enum
# end
module SearchableModels
  module Searchable
    extend ActiveSupport::Concern

    included do
      mattr_accessor :search_fields, :instance_accessor => false do
        {}
      end

      mattr_accessor :search_order, :instance_accessor => false do
        :id
      end

      define_singleton_method(:search) do |params|
        results = all

        fields = search_fields.select do |_, v|
          v.try(:exclude?, :mode) \
            || %i(exact scope enum).include?(v.try(:[], :mode))
        end
        results = _search(results, fields, params)

        fields = search_fields.select { |_, v| v.try(:[], :mode) == :fuzzy }
        results = _fuzzy_search(results, fields, params)

        results.uniq.order(search_order)
      end
    end

    module ClassMethods
      def search_on(*args)
        self.search_fields.merge!(args.first => args.extract_options!)
      end

      def search_ordered_by(field)
        self.search_order = field
      end

      private

      ## private search util functions, not part of the public API
      def _search(results, fields, params)
        fields.each do |field, options|
          next unless (value = params[options[:param] || field])
          results = case
                    when field == :tags
                      _tags_search(results, value, params[:tags_combination])
                    when field =~ /_id(?:s)?$/ && options[:through]
                      _association_ids_search(results, field, value, options[:through])
                    when options[:mode] == :scope && options[:scope]
                      _search_with_scope(results, value, options[:scope])
                    when options[:mode] == :enum
                      _search_with_enum(results, field, value)
                    else
                      _simple_search(results, field, value)
                    end
        end
        results
      end

      def _fuzzy_search(results, fields, params)
        searchable_fields = {}
        fields.each do |field, options|
          _check_type_for_fuzzy_search(field)
          param_key = options[:param] || field
          searchable_fields[param_key] ||= []
          searchable_fields[param_key] << field
        end

        searchable_fields.each do |param_key, columns|
          next unless params[param_key]
          where_string = ""
          columns.each do |column|
            where_string << " OR " unless where_string.blank?
            table = table_name
            if try(:translated?, column)
              table = translation_options[:table_name]
              results = results.joins(:translations)
            end
            where_string << "LOWER(#{table}.#{column}) like :value"
          end
          condition = { :value => "%#{params[param_key].to_s.downcase}%" }
          results = results.where("(#{where_string})", condition)
        end
        results
      end

      def _tags_search(results, value, tags_combination = "AND")
        return results unless value.try(:any?)
        case tags_combination
        when "OR"
          results.tagged_with(value, :any => true)
        else
          results.tagged_with(value)
        end
      end

      def _search_with_scope(results, value, scope)
        results.send(scope, value)
      end

      def _search_with_enum(results, field, value)
        results.where(field => send(field.to_s.pluralize).try(:[], value))
      end

      def _simple_search(results, field, value)
        results.where(field => value)
      end

      def _association_ids_search(results, field, value, through)
        return results unless through
        table = _get_last_value(through).to_s.pluralize
        results.joins(through).where(table => { field => value })
      end

      def _get_last_value(object)
        return _get_last_value(object.first.last) if object.is_a?(Hash)
        object
      end

      def _through_association_ids_search(results, field, value, through)
        return results unless through
        results.joins(through).where(through => { field => value })
      end

      def _check_type_for_fuzzy_search(field)
        return if try(:translated?, field) \
          || columns_hash[field.to_s].try(:type) == :string
        fail(ArgumentError, "#{field} must of type string to run a fuzzy search")
      end
    end
  end
end

ActiveRecord::Base.send(:include, SearchableModels::Searchable)

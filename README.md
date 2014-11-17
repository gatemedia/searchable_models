# SearchableModels
[![Build Status](https://travis-ci.org/gatemedia/searchable_models.svg?branch=master)](https://travis-ci.org/gatemedia/searchable_models)

SearchableModels provide a `search` scope on ActiveRecord models.

This idea is to describe which fields are searchable and the gem will do the rest. You just need to call the  `#search` method and you're set.

## Compatibility

SearchableModels has been used with:
* ruby 2
* rails 4.1

However this gem is built against:
* ruby 1.9.3
* ruby 2.0.0
* ruby 2.1.3

Other versions may or may not work.



## Installation

To use it, add it to your Gemfile:

```ruby
gem 'searchable_models', '~> 0.1'
```

and bundle:

```shell
bundle
```

## Usage

You just need to use the `search_on` function in your models and the scope `search` will be available on your model.

There are different types of search. See below for the details.

### Simple search
This is the simplest search you could do. It will search for an exact match.

```ruby
class Car < ActiveRecord::Base
  search_on :name
  search_on :number_of_doors
end
```

We can then search `Car`s with:
```ruby
Car.search(:name => "Ferrari")
Car.search(:number_of_doors => 3)
Car.search(:name => "Porsche", :number_of_doors => 4)
```

This search will join all the conditions with an AND. It will use an exact match. This search can be done on any type of field: strings, integer and others.

### Fuzzy search
This search is similar to the simple search but will use a fuzzy operator instead of an exact match. This *must* used on string fields.

```ruby
class Car < ActiveRecord::Base
  search_on :name, :mode => :fuzzy
end
```

```ruby
Car.search(:name => "rari")
Car.search(:name => "rsche")
```

Note that the search is case insensitive.

### Grouped search
Sometimes we want to use the same input parameter for several fields. For this, we can group the search.

```ruby
class Car < ActiveRecord::Base
  search_on :name, :mode => :fuzzy, :param => :query
  search_on :model, :param => :query
end
```

```ruby
Car.search(:query => "rari")
Car.search(:query => "Dodge")
```

You can group a simple and a fuzzy search together.

### Rename input parameter
The `param` option can also be used to rename the input parameter. Let's you want to map the parameter `car_name` to the column `name`:

```ruby
class Car < ActiveRecord::Base
  search_on :name, :mode => :fuzzy, :param => :car_name
end
```

```ruby
Car.search(:car_name => "rari")
```

This feature can be used with any type of search.

### Reference search
You can search on a `belongs_to` reference column.

```ruby
class Car < ActiveRecord::Base
  belongs_to :fleet
  search_on :fleet_id
end
```

```ruby
Car.search(:fleet_id)
```

### Search on associated table
You can search on a column of an associated table

```ruby
class Car < ActiveRecord::Base
  has_many :components
  search_on :provider_name, :mode => :fuzzy, :through => :components
end
```

```ruby
Car.search(:provider_name => "Toshi")
```

The `through` option is not limited to one table, you can nest as many as tables you may need

```ruby
class Car < ActiveRecord::Base
  has_one :engine
  search_on :provider_name, :mode => :fuzzy, :through => { :engine => :components }
end
```

### Scope search
You may want to use a custom scope in your search.

```ruby
class Car < ActiveRecord::Base
  scope :imported_on, ->(date) { where(:import_date => date) }

  search_on :import_date, :mode => :scope, :scope => :imported_on
end
```

```ruby
Car.search(:import_date => "1990-10-10")
```

This feature is limited to scopes with only one parameter.

### Enum search
You can search using a field declared as a Rails 4 enum.

```ruby
class Car < ActiveRecord::Base
  enum :kind => %i(van sedan family)
  search_on :kind, :mode => :enum
end
```

```ruby
Car.search(:kind => "van")
```

### `acts-as-taggable-on` support
If your model is tagged with [acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on), you can create a search on the tags. By default, all the tags conditions are merged using *AND* but you can specify an *OR* merge if you want.


```ruby
class Car < ActiveRecord::Base
  acts_as_taggable
  search_on :tags
end
```

```ruby
Car.search(:tags => [:blue, :old])
Car.search(:tags => [:blue, :yellow, :red], :tags_combination => :or)
```

### `globalize` support
If your model is translated using [https://github.com/globalize/globalize](Globalize), you can create a search on the translated fields.

```ruby
class Car < ActiveRecord::Base
  translates :commercial_name
  search_on :commercial_name, :mode => :fuzzy
end
```

```ruby
Car.search(:commercial_name => "van")
```

You can use an exact or a fuzzy search on translated fields

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This project rocks and uses MIT-LICENSE.

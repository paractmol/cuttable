# cuttable
Escape SQL injection when you order with params

# Getting started

1. Add inside your Gemfile

```
  gem 'cuttable'
```

2. Include concern and execute default_order to set default order for
sanitize_order method.

```ruby
class User < ActiveRecord::Base
  include Cuttable        # include concern
  default_order 'id desc' # set default order for sanitize_order method
end
```

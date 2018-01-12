# cuttable
Escape SQL injection when you order with params

## Getting started

1. Add inside your Gemfile

       gem 'cuttable'


2. Include concern and execute default_order to set default order for
sanitize_order method.

  ```ruby
  class User < ActiveRecord::Base
    include Cuttable        # include concern
    default_order 'id desc' # set default order for sanitize_order method
  end
  ```

## Usage

```ruby
# good queries
params[:order] = 'id DESC'
User.sanitize_order(params[:order])

params[:order] = 'id, username DESC'
User.sanitize_order(params[:order])

# bad query
params[:order] = 'id, (select sleep(2000) from dual where database() like database())#'
# it should back off to the default query you set with default_order
User.sanitize_order(params[:order])
```

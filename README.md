## ActiveResource-Response
This gem adds the ability to access the HTTP response (`Net::HTTPResponse`) object from the result (either a single object or a collection) of an ActiveResource call (methods: `find`, `all`, `first`, `last`, `get`).

#### Why Can It Be Used?
This functionality can be used to easily implement pagination in a REST API, so that an ActiveResource client can navigate paginated results.

#### How to Use?
Add the dependency to your `Gemfile`:

```ruby
gem "activeresource-response"
```

Open your ActiveResource class and add:

```ruby
add_response_method :your_method_name
```

You can add the method to `ActiveResource::Base` to use it in all subclasses:

```ruby
class ActiveResource::Base
  add_response_method :my_response  
end
```

You can remove the method from an ActiveResource subclass:

```ruby
class Order < ActiveResource::Base
  remove_response_method  
end
```

## Full Example of Usage with the Kaminari Gem

ActiveResource Class:

```ruby
class Order < ActiveResource::Base
  self.format = :json
  self.site = 'http://0.0.0.0:3000/'
  self.element_name = "order" 
  add_response_method :http_response  # Our new method for returned objects
end
```

Server Side:

```ruby
class OrdersController < ApplicationController
  def index
    @orders = Order.page(params[:page]).per(params[:per_page] || 10) # default 10 per page
    response.headers["X-total"] = @orders.total_count.to_s
    response.headers["X-offset"] = @orders.offset_value.to_s
    response.headers["X-limit"] = @orders.limit_value.to_s
    respond_with(@orders)
  end
end
```

Client Side:

```ruby
class OrdersController < ApplicationController
  def index
    orders = Order.all(params: params)     
    @orders = Kaminari::PaginatableArray.new(orders, {
      limit: orders.http_response['X-limit'].to_i,
      offset: orders.http_response['X-offset'].to_i,
      total_count: orders.http_response['X-total'].to_i
    }) 
  end
end
```

### Will_paginate Compatibility
`will_paginate` has a slightly different API, so to populate the headers:

```ruby
response.headers["X-total"] = @orders.total_entries.to_s
response.headers["X-offset"] = @orders.offset.to_s
response.headers["X-limit"] = @orders.per_page.to_s
```

On the API client side, you might also use `will_paginate`. In that case, you can just require `will_paginate/array` (e.g., in an initializer):

```ruby
orders = Order.all(params: params)     
@orders = WillPaginate::Collection.create(params[:page] || 1, params[:per_page] || 10, orders.http_response['X-total'].to_i) do |pager|
  pager.replace orders
end
```

### Every Time an HTTP Connection is Invoked
The ActiveResource connection object stores the HTTP response. You can access it with the `http_response` method. 

Example:

```ruby
class Order < ActiveResource::Base
  self.site = 'http://0.0.0.0:3000/'
  self.element_name = "order" 
  add_response_method :my_response  # Our new method 
end

orders = Order.all
first_order = Order.find(1) 
# See Net::HTTPResponse#[] method
orders.my_response['content-length'] 
# => "3831" 
first_order.my_response['content-length'] 
# => "260"
# Connection also always has the last HTTP response object. To access it, use the http_response method:
Order.connection.http_response.to_hash
# => {"content-type"=>["application/json; charset=utf-8"], "x-ua-compatible"=>["IE=Edge"], "etag"=>["\"573cabd02b2f1f90405f7f4f77995fab\""], "cache-control"=>["max-age=0, private, must-revalidate"], "x-request-id"=>["2911c13a0c781044c474450ed789613d"], "x-runtime"=>["0.071018"], "content-length"=>["260"], "server"=>["WEBrick/1.3.1 (Ruby/1.9.2/2011-02-18)"], "date"=>["Sun, 19 Feb 2012 10:21:29 GMT"], "connection"=>["close"]} 
```

### Custom `get` Method
You can access the response from the result of a custom `get` method.

Example:

```ruby
class Country < ActiveResource::Base
  self.site = 'http://0.0.0.0:3000/'
  add_response_method :http  # Our new method
end

cities = Country.find(1).get(:cities)
cities.http  # Method from the Country class is available
```

### Headers and Cookies Methods
You can get cookies and headers from the response.

Example:

```ruby
class Country < ActiveResource::Base
  self.site = 'http://0.0.0.0:3000/'
  add_response_method :my_response  # Our new method
end

countries = Country.all
countries.my_response.headers

# Collection with symbolized keys:
# {:content_type=>["application/json; charset=utf-8"], :x_ua_compatible=>["IE=Edge"], ..., :set_cookie=>["bar=foo; path=/", "foo=bar; path=/"]}

countries.my_response.cookies
# => {"bar"=>"foo", "foo"=>"bar"}   
```

### Note About HTTP Response
The HTTP response is an object of `Net::HTTPOK`, `Net::HTTPClientError`, or one of the other subclasses of the `Net::HTTPResponse` class. For more information, see the documentation: [Net::HTTPResponse](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTPResponse.html).

### Testing with ActiveResource::HttpMock
Add this line to your test to patch `http_mock`:

```ruby
require "active_resource_response/http_mock"
```

### Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Please feel free to contact me if you have any questions:
fedoronchuk(at)gmail.com



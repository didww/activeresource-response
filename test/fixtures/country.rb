class ActiveResourceResponseBase < ActiveResource::Base
  self.site = "http://37s.sunrise.i:3000"
  add_response_method :http_response
end


class Country < ActiveResourceResponseBase
  add_response_method :http
end
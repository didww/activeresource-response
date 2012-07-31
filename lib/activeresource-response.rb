require 'cgi'
require "activeresource-response/version"
require "activeresource-response/http_response"
require "activeresource-response/connection"
require "activeresource-response/response_method"
ActiveResource::Connection.send :include, ActiveresourceResponse::Connection
ActiveResource::Base.send :include, ActiveresourceResponse::ResponseMethod
if defined? ActiveResource::Response
   require "activeresource-response/response"
   ActiveResource::Response.send :include, ActiveresourceResponse::Response

end
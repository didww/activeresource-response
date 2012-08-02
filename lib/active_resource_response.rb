require 'cgi'
require 'active_resource'
require "active_resource_response/version"
require "active_resource_response/http_response"
require "active_resource_response/connection"
require "active_resource_response/response_method"
ActiveResource::Connection.send :include, ActiveResourceResponse::Connection
ActiveResource::Base.send :include, ActiveResourceResponse::ResponseMethod
if defined? ActiveResource::Response
   require "active_resource_response/response"
   ActiveResource::Response.send :include, ActiveResourceResponse::Response

end
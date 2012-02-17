require "activeresource-response/version"
require "activeresource-response/connection"
require "activeresource-response/add_response_method"
ActiveResource::Connection.send :include, ActiveresourceResponse::Connection
ActiveResource::Base.send :include, ActiveresourceResponse::AddResponseMethod
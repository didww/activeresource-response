module ActiveresourceResponse
   module Connection
     def self.included(base)
       base.class_eval  do
           alias_method :origin_handle_response, :handle_response 
           def handle_response(response)
             Thread.current[:ActiveResourceHttpResponse] = response
             origin_handle_response(response)
           end
           def http_response
              Thread.current[:ActiveResourceHttpResponse]
           end    
        end
     end 
   end
end
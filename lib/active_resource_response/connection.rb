module ActiveResourceResponse
   module Connection
     def self.included(base)
       base.class_eval  do
           alias_method :origin_handle_response, :handle_response 
           def handle_response(response)
             begin
               origin_handle_response(response)
             rescue StandardError => e
               raise e
             end
             response.extend(ActiveResourceResponse::HttpResponse)
            
             Thread.current[:ActiveResourceResponse] = response
           end
           def http_response
              Thread.current[:ActiveResourceResponse]
           end    
        end
     end 
   end
end
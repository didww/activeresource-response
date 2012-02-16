require "activeresource-response/version"
module ActiveresourceResponse
   module Connection
     def self.included(base)
       base.class_eval  do
           alias_method :origin_handle_response, :handle_response 
           def handle_response(response)
             Thread.current['ActiveResource::Base.http_response'] = response
             origin_handle_response(response)
           end
           def http_response
              Thread.current['ActiveResource::Base.http_response']
           end    
        end
     end 
   end   
   module AddResponseMethod
     def self.included(base)
        base.extend ClassMethods
      end
      module ClassMethods
         def add_response_method(method_name = 'http_response')
             class_eval  <<-EOS
               class << self
                 alias_method :origin_find, :find
                 def find(*arguments)
                     result = origin_find(*arguments)
                     result.class_eval("attr_reader :#{method_name}")
                     result.instance_variable_set(:"@#{method_name}", connection.http_response)
                     result
                 end
                end 
             EOS
         end   
      end
   end   
end
ActiveResource::Connection.send :include, ActiveresourceResponse::Connection
ActiveResource::Base.send :include, ActiveresourceResponse::AddResponseMethod
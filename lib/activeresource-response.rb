require "activeresource-response/version"
module ActiveresourceResponse
   module AddResponseMethod
     def self.included(base)
        base.extend ClassMethods
      end
      module ClassMethods
         def add_response_method(method_name = 'response')
            
            connection.class_eval  <<-EOS
                alias_method :origin_handle_response, :handle_response 
                attr_reader :#{method_name}
                def handle_response(response)
                  @#{method_name}= response
                  origin_handle_response(response)
                end
             EOS
          
             class_eval  <<-EOS
               class << self
                 alias_method :origin_find, :find
                 def find(*arguments)
                     result = origin_find(*arguments)
                     result.class_eval("attr_reader :#{method_name}")
                     result.instance_variable_set(:"@#{method_name}", connection.#{method_name})
                     result
                 end
                end 
             EOS
         end   
      end
   end   
end

ActiveResource::Base.send :include, ActiveresourceResponse::AddResponseMethod
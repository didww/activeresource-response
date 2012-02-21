module ActiveresourceResponse  
   module AddResponseMethod
     def self.included(base)        
        base.extend ClassMethods
      end
      module ClassMethods
         def add_response_method(method_name = 'http_response')
           [:find, :get].each do |method| 
             class_eval  <<-EOS
               class << self
                 alias_method :origin_#{method}, :#{method}
                 def #{method}(*arguments)
                     result = origin_#{method}(*arguments)
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
end
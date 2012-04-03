module ActiveresourceResponse
   module HttpResponse
       def headers
         @_active_resource_response_headers || symbolize_keys(to_hash)
       end
       def cookies
          unless @_active_resource_response_cookies
             cookies   = (self.headers[:set_cookie] || {}).inject({}) do |out, cookie_str|    
               CGI::Cookie::parse(cookie_str).each do |key, cookie|  
                 out[key] = cookie.value.first unless ['expires', 'path'].include? key 
               end
               out
            end
            @_active_resource_response_cookies = symbolize_keys(cookies)
          end  
          @_active_resource_response_cookies
       end
       
       private
       def symbolize_keys(hash)
         hash.inject({}) do |out, (key, value)|
             out[key.gsub(/-/, '_').downcase.to_sym] = value
             out
         end
       end   
       
   end
end
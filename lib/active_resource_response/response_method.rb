#--
# Copyright (c) 2012 Igor Fedoronchuk
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
module ActiveResourceResponse

  module ResponseMethod
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def add_response_method(method_name = :http_response)

        remove_response_method  if methods.map(&:to_sym).include?(:find_without_http_response)
        [:find, :get].each do |method| 
          instance_eval  <<-EOS
          alias #{method}_without_http_response #{method}
          def #{method}(*arguments)
            result = #{method}_without_http_response(*arguments)
            result.instance_variable_set(:@http_response, connection.http_response)
            def result.#{method_name} 
              @http_response
            end   
            result
          end
          EOS
        end
      end

      def remove_response_method
        [:find, :get].each do |method| 
          instance_eval   <<-EOS
            undef :#{method}
            alias :#{method} :#{method}_without_http_response 
            undef :#{method}_without_http_response
          EOS
                     
        end 
      end   

    end
  end   
end

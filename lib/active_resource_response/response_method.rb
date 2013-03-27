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

      def http_response
        connection.http_response
      end

      def add_response_method(method_name = :http_response)
        class_attribute :http_response_method
        self.http_response_method = method_name 
        class << self
          alias :find_without_http_response :find

          def find(*arguments)
            result = find_without_http_response(*arguments)
            self.merge_response_to_result(result)
          end
        end unless methods.map(&:to_sym).include?(:find_without_http_response)
      end
      
      def remove_response_method
         class << self
            undef :find
            alias :find :find_without_http_response
            undef :find_without_http_response
            undef :http_response_method
            undef :http_response_method=
         end
      end

      def merge_response_to_result(result)
        begin
          result.instance_variable_set(:@http_response, connection.http_response)
          (class << result; self; end).send(:define_method, self.http_response_method) do
            @http_response
          end 
        rescue StandardError

        end
        result
      end
    end
  end
end

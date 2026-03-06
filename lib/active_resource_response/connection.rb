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
  module Connection
    class Current < ActiveSupport::CurrentAttributes
      attribute :http_responses, default: {}

      def http_response(klass)
        http_responses[klass]
      end

      def set_http_response(klass, response)
        http_responses[klass] = response
      end
    end

    def self.included(base)
      base.class_eval do
        alias_method :origin_handle_response, :handle_response

        def handle_response(response)
          begin
            origin_handle_response(response)
          rescue
            raise
          ensure
            response.extend HttpResponse
            self.http_response=(response)
          end
        end

        def http_response
          Current.http_response(self.class)
        end

        def http_response=(response)
          Current.set_http_response self.class, response
        end
      end
    end
  end
end

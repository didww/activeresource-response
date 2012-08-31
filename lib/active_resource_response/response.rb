module ActiveResourceResponse
  module Response
    def self.included(base)
      base.class_eval  do
        def to_hash
          @headers
        end
        # to avoid method name conflict with Response:HttpResponse:headers
        def [](key)
          @headers[key]
        end
      end
    end
  end
end

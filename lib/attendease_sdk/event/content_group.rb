module AttendeaseSDK
  module EventApi
    class ContentGroup
      def initialize(params = {})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def self.list
        # /api/events/:event_id/content_groups/:section(.:format)
        response = HTTParty.get("#{AttendeaseSDK.event_base_url}content", :headers => AttendeaseSDK.event_headers)
        case response.code
        when 200
          response.parsed_response
        when 422
          raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
        else
          raise ConnectionError.new(), "#{response["error"]}"
        end
      end
    end
  end
end

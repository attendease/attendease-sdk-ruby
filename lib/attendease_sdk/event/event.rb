module AttendeaseSDK
  module EventApi
    class Event
      def initialize(params = {})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def self.retrieve
        # /api/events/:event_id/content_groups/:section(.:format)
        response = HTTParty.get("#{AttendeaseSDK.event_base_url}" + "event.json")
        case response.code
        when 200
          # Attendee.new(response.parsed_response)
          response.parsed_response
        when 422
          raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
        else
          raise ConnectionError.new(), response.parsed_response
        end
      end
    end
  end
end

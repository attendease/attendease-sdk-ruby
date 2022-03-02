
module AttendeaseSDK

  class Day

    attr_accessor :id, :date, :start_time, :end_time

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(day_id)
      # GET /api/events/:event_id/days/:id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/days/#{day_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.list
      # GET /api/events/:event_id/days(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/days.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(day_hash)
      # POST /api/events/:event_id/days(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/days.json", :headers => AttendeaseSDK.admin_headers, :body => day_hash.to_json)

      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(day_hash)
      # PUT /api/events/:event_id/days/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/days/#{day_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => day_hash.to_json)

      case response.code
      when 204
        day_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.destroy(day_id)
      # DELETE /api/events/:event_id/days/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/days/#{day_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 204
        # response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end
  end
end

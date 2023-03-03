
module AttendeaseSDK

  class Session

    attr_accessor :id, :name, :private

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(session_id)
      # GET /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        # Session.new(response.parsed_response)
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.list(options = {})
      if options['instances'] == true
        # GET /api/sessions(.:format)
        response = HTTParty.get("#{AttendeaseSDK.event_base_url}" + "sessions.json?meta=true", :headers => AttendeaseSDK.event_headers)
      else
        # GET /api/events/:event_id/sessions(.:format)
        response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions.json", :headers => AttendeaseSDK.admin_headers)
      end

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.create(session_hash)
      # POST /api/events/:event_id/sessions(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions.json", :headers => AttendeaseSDK.admin_headers, :body => session_hash.to_json)

      case response.code
      when 201
        # Session.new(response.parsed_response)
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.update(session_hash)
      # PUT /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => session_hash.to_json)

      case response.code
      when 204
        # Session.new(session_hash)
        session_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
      # responds with a 204
    end

    def self.destroy(session_id)
      # DELETE /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 204
        # response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end
  end
end

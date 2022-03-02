module AttendeaseSDK

  class Instance
    attr_accessor :id, :name

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(session_id, instance_id)
      # GET /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/instances/#{instance_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.list(session_id)
      # GET /api/events/:event_id/sessions/:session_id/instances
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/instances.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(session_id, instance_hash)
      # POST /api/events/:event_id/sessions/:session_id/instances(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/instances.json", :headers => AttendeaseSDK.admin_headers, :body => instance_hash.to_json)

      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(session_id, instance_hash)
      # PUT /api/events/:event_id/sessions/:session_id/instances/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/instances/#{instance_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => instance_hash.to_json)

      case response.code
      when 204
        instance_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
      # responds with a 204
    end

    def self.destroy(session_id, instance_hash)
      # DELETE /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/instances/#{instance_hash['id']}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 204
        instance_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end
  end
end

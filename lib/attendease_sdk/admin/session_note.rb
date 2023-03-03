module AttendeaseSDK

  class SessionNote

    attr_accessor :id, :name, :url, :user_id

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end


    def self.list(session_id)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/notes.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.create(session_id, note_hash)
      # POST /api/events/:event_id/sessions(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/notes.json", :headers => AttendeaseSDK.admin_headers, :body => note_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.update(session_id, note_id, note_hash)
      # PUT /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/notes/#{note_id}.json", :headers => AttendeaseSDK.admin_headers, :body => note_hash.to_json)

      case response.code
      when 204
        note_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
      # responds with a 204
    end

    def self.destroy(session_id, note_id)
      # DELETE /api/events/:event_id/sessions/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/sessions/#{session_id}/#{note_id}.json", :headers => AttendeaseSDK.admin_headers)

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

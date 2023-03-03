
module AttendeaseSDK

  class Filter

    attr_accessor :id, :name, :colour, :private, :filter_items

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(filter_id)
      # GET /api/events/:event_id/filter_groups/:id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.list
      # GET /api/events/:event_id/filters(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.create(filter_hash)
      # POST /api/events/:event_id/filters(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups.json", :headers => AttendeaseSDK.admin_headers, :body => filter_hash.to_json)

      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.update(filter_hash)
      # PUT /api/events/:event_id/filter_groups/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => filter_hash.to_json)

      case response.code
      when 204
        filter_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.destroy(filter_id)
      # DELETE /api/events/:event_id/filter_groups/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}.json", :headers => AttendeaseSDK.admin_headers)

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

module AttendeaseSDK

  class FilterItem

    attr_accessor :id, :name, :colour

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(filter_id, filter_item_id)
      # GET /api/events/:event_id/filter_items/:id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}/filter_items/#{filter_item_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.list(filter_id)
      # GET /api/events/:event_id/filter_groups/#{filter_id}/filter_items(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}/filter_items.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(filter_id, filter_item_hash)
      # POST /api/events/:event_id/filter_groups/#{filter_id}/filter_items(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}/filter_items.json", :headers => AttendeaseSDK.admin_headers, :body => filter_item_hash.to_json)

      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(filter_id, filter_item_hash)
      # PUT /api/events/:event_id/filter_groups/#{filter_id}/filter_items/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}/filter_items/#{filter_item_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => filter_item_hash.to_json)

      case response.code
      when 204
        filter_item_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.destroy(filter_id, filter_item_id)
      # DELETE /api/events/:event_id/filter_groups/#{filter_id}/filter_items/:id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/filter_groups/#{filter_id}/filter_items/#{filter_item_id}.json", :headers => AttendeaseSDK.admin_headers)

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

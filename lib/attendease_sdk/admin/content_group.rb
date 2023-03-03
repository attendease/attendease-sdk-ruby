module AttendeaseSDK

  class ContentGroup

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.update(content_group_id, content_group_section, content_group_hash)
      # /api/events/:event_id/content_groups/:section/:content_group_id/items/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/content_groups/#{content_group_section}/#{content_group_id}.json", :headers => AttendeaseSDK.admin_headers, :body => content_group_hash.to_json)
      case response.code
      when 204
        content_item_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

  end

end

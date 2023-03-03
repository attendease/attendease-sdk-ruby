module AttendeaseSDK

  class ContentItem

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end
    # group['id'], group['section'], content_item_hash
    def self.update(section ,content_group_id, content_item_hash)
      # /api/events/:event_id/content_groups/:section/:content_group_id/items/:id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/content_groups/#{section}/#{content_group_id}/items/#{content_item_hash['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => content_item_hash.to_json)
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

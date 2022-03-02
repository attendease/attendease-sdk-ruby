module AttendeaseSDK

  class Event
    attr_accessor :id, :name, :url, :host, :path, :third_party_registration, :subdomain, :archived, :published, :republish, :days, :meta

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.subdomain
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "admin/events/subdomain/" + "#{AttendeaseSDK.event_subdomain}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.retrieve(options = {})
      # GET /api/events/:event_id(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        if options.fetch('object',false)
          Event.new(response.parsed_response)
        else
          response.parsed_response
        end
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.list
      # GET /api/events(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(event_hash, options={})
      # POST /api/events(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events.json", :headers => AttendeaseSDK.admin_headers, :body => event_hash.to_json)
      case response.code
      when 201
        if options.fetch('object',false)
          Event.new(response.parsed_response)
        else
          response.parsed_response
        end
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(event_hash, options={})
      # PUT /api/events/:event_id(.:format)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}.json", :headers => AttendeaseSDK.admin_headers, :body => event_hash.to_json)
      case response.code
      when 204
        if options.fetch('object',false)
          Event.new(event_hash)
        else
          event_hash
        end
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.destroy(event_id)
      # DELETE /api/events/:event_id(.:format)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" "#{AttendeaseSDK.event_id}.json", :headers => AttendeaseSDK.admin_headers)

      case response.code
      when 204
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.publish(options = {})

      update_from_theme_template = options.fetch('update_from_theme_template', 'false')

      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/publish.json" + "?update_from_theme_template=#{update_from_theme_template}", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.unpublish
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/unpublish.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end
  end
end

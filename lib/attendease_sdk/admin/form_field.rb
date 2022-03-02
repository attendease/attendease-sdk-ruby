module AttendeaseSDK

  class FormField
    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.list(organization_id, options = {})
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/form_fields.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(organization_id, form_field_hash)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/form_fields.json", :headers => AttendeaseSDK.admin_headers, :body => form_field_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(organization_id, form_field_id, form_field_hash)
      form_field_hash['field_options_attributes'] = form_field_hash['field_options']
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/form_fields/#{form_field_id}.json", :headers => AttendeaseSDK.admin_headers, :body => form_field_hash.to_json)
      case response.code
      when 204
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

  end
end

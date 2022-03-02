module AttendeaseSDK

  class MetadataDescriptor
    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.list(organization_id, options = {})
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/metadata_descriptors.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(organization_id, descriptors_hash)
      descriptors_hash = {metadata_descriptor: descriptors_hash}
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/metadata_descriptors.json", :headers => AttendeaseSDK.admin_headers, :body => descriptors_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(organization_id, org_metadata_descriptor_id, descriptors_hash)
      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}" + "/metadata_descriptors/#{org_metadata_descriptor_id}.json", :headers => AttendeaseSDK.admin_headers, :body => descriptors_hash.to_json)
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

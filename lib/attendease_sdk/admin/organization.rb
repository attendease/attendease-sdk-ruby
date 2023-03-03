module AttendeaseSDK

  class Organization
    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.subdomain
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "admin/organizations/subdomain/" + "#{AttendeaseSDK.subdomain}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.list(options = {})
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/organizations.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.retrieve(organization_id)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/organizations/" + "#{organization_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.create(organization_hash)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/organizations.json", :headers => AttendeaseSDK.admin_headers, :body => organization_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

  end
end

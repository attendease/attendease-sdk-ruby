module AttendeaseSDK
  class User
    attr_accessor :id, :name, :active, :description

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.list(organization_id)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/organizations" + "/#{organization_id}/users.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

  end
end

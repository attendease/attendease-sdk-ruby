
module AttendeaseSDK
  ### Presenter
  class PassGroup

    attr_accessor :name, :description, :start_availability, :end_availability

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.create(pass_group_hash)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/pass_groups.json", :headers => AttendeaseSDK.admin_headers, :body => pass_group_hash.to_json)
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

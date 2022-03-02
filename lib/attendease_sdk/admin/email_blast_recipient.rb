require 'active_support/all'

module AttendeaseSDK
  class EmailBlastRecipient
    attr_accessor :id

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(blast_id, email_blast_recipients_id)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients/#{email_blast_recipients_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.list(blast_id)
      # /api/events/:event_id/blasts/:blast_id/email_blast_recipients(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.create(blast_id, email_recipients_hash)
      email_recipients_hash = set_recipient_hash(email_recipients_hash)

      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients.json", :headers => AttendeaseSDK.admin_headers, :body => email_recipients_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.update(blast_id, email_recipients_hash)
      email_recipients_hash = set_recipient_hash(email_recipients_hash)

      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients/#{email_recipients_hash['email_recipient']['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => email_recipients_hash.to_json)
      case response.code
      when 204
        email_recipients_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.destroy(blast_id, email_recipients_id)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients/#{email_recipients_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 204
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    def self.deliver(blast_id, email_recipients_id)
      # /api/events/:event_id/blasts/:id/deliver(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/email_recipients/#{email_recipients_id}/deliver.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), response.parsed_response
      end
    end

    # HTTParty does not currently support files. This will require additional
    # invstigation to find an alternative http service that will facililtate this.

    # def self.import(blast_id, recipient_csv)
    #
    #   AttendeaseSDK.admin_headers = {
    #     "Content-Type" => "multipart/form-data",
    #     "X-User-Token" => AttendeaseSDK.user_token,
    #   }
    #   # /api/events/:event_id/blasts/:blast_id/email_recipients/import(.:format)
    #   arr_attendee_ids = set_attendeee_ids_hash(attendee_ids_arr)
    #   response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/import.json", :headers => AttendeaseSDK.admin_headers, :body => recipient_csv)
    #   case response.code
    #   when 201
    #     response.parsed_response
    #   when 422
    #     raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
    #   else
    #     raise ConnectionError.new(), response.parsed_response
    #   end
    # end

    def self.set_recipient_hash(email_recipients_hash)
      email_recipients_hash = if email_recipients_hash['email_recipient'].blank?
        email_recipients_hash = {
          'email_recipient' => email_recipients_hash
          }
      else
        email_recipients_hash
      end
    end
  end
end

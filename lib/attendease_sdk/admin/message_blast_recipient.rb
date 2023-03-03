require 'active_support/all'

module AttendeaseSDK
  class MessageBlastRecipient
    attr_accessor :id 

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.retrieve(blast_id, message_blast_recipients_id)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients/#{message_blast_recipients_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.list(blast_id)
      # /api/events/:event_id/blasts/:blast_id/message_blast_recipients(.:format)
      response = HTTParty.get("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 200
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.create(blast_id, message_recipients_hash)
      message_recipients_hash = set_recipient_hash(message_recipients_hash)

      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients.json", :headers => AttendeaseSDK.admin_headers, :body => message_recipients_hash.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.update(blast_id, message_recipients_hash)
      message_recipients_hash = set_recipient_hash(message_recipients_hash)

      response = HTTParty.put("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients/#{message_recipients_hash['recipient']['id']}.json", :headers => AttendeaseSDK.admin_headers, :body => message_recipients_hash.to_json)
      case response.code
      when 204
        message_recipients_hash
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.destroy(blast_id, message_recipients_id)
      response = HTTParty.delete("#{AttendeaseSDK.admin_base_url}" + "api/events/" "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients/#{message_recipients_id}.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 204
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.deliver(blast_id, message_recipients_id)
      # /api/events/:event_id/blasts/:id/deliver(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients/#{message_recipients_id}/deliver.json", :headers => AttendeaseSDK.admin_headers)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end


    def self.add(blast_id, attendee_ids_arr)

      arr_attendee_ids = set_attendeee_ids_hash(attendee_ids_arr)
      # /api/events/:event_id/blasts/:blast_id/message_blast_recipients/add(.:format)
      response = HTTParty.post("#{AttendeaseSDK.admin_base_url}" + "api/events/" + "#{AttendeaseSDK.event_id}/blasts/#{blast_id}/message_blast_recipients/add.json", :headers => AttendeaseSDK.admin_headers, :body => arr_attendee_ids.to_json)
      case response.code
      when 201
        response.parsed_response
      when 422
        raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
      else
        raise ConnectionError.new(), "#{response["error"]}"
      end
    end

    def self.set_recipient_hash(message_recipients_hash)
      message_recipients_hash = if message_recipients_hash['recipient'].blank?
        message_recipients_hash = {
          'recipient' => message_recipients_hash
          }
      else
        message_recipients_hash
      end
    end

    def self.set_attendeee_ids_hash(attendee_ids_arr)
      attendee_ids_arr = {
        'attendee_ids' => attendee_ids_arr.to_s
        }
    end
  end
end

module AttendeaseSDK
  module Org
    class Organization

      attr_accessor :archived, :dates, :days, :meta, :archived, :name, :subdomain, :end_time, :organization_id, :payment_methods

      def initialize(params = {})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def self.retrieve_event(event_id)
        response = HTTParty.get("#{AttendeaseSDK.organization_base_url}" + "v2/events/" + "#{event_id}.json", :headers => AttendeaseSDK.admin_headers)
        case response.code
        when 200
          response.parsed_response
        when 422
          raise DomainError.new(response.parsed_response['errors'].to_a.map{|error| "#{error[0]} #{error[1].join(",") }"}.join(", "))
        else
          raise ConnectionError.new(), response.parsed_response
        end
      end

      def self.events(options={})

        status_option = options.fetch('status', 'all')
        before_date   = options.fetch('before', nil)
        after_date    = options.fetch('after', nil)
        total_records = options.fetch('records_per_page', '500')
        meta          = options.fetch('meta', nil)

        params = {}

        if status_option.present?
          params['status'] = status_option
        end

        if before_date.present?
          # delete to remove any whitespaces in the date format
          params['before_date'] = before_date.to_time.iso8601
        end

        if after_date.present?
          params['after_date'] = after_date.to_time.iso8601
        end

        if total_records.present?
          params['records_per_page'] = total_records
        end

        if meta.present?
          meta.each do |k,v|
            params["meta[#{k}]"] = v
          end
        end
        params_string = params.map{|k,v| "#{k}=#{v}"}.join('&')

        response = HTTParty.get("#{AttendeaseSDK.organization_base_url}" + "v2/" "events.json?#{params_string}", :headers => AttendeaseSDK.admin_headers)

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
end

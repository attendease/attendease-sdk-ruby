$:.unshift File.dirname(__FILE__)
require 'active_support/all'
require 'attendease_sdk/version'
require 'attendease_sdk/admin/attendease_sdk_admin'
require 'attendease_sdk/organization/attendease_sdk_organization'
require 'attendease_sdk/event/attendease_sdk_event'
require 'httparty'

module AttendeaseSDK

  class << self

    attr_accessor :user_token, :event_token, :event_id, :environment, :event_subdomain, :subdomain

    def event_subdomain=(value)
      @event_subdomain = value
      if event_id.blank?
        set_event_id
      end
    end

    def set_event_id
      begin
        event_properties = AttendeaseSDK::Event.subdomain
      rescue AttendeaseSDK::ConnectionError => e
        puts "Error Properties for subdomain: #{@event_subdomain} failed to be retrieved - reason: #{e.message}"
      rescue AttendeaseSDK::DomainError => e
        puts "Error Properties subdomain: #{@event_subdomain} failed to be retrieved - reason: #{e.message}"
      end

      if event_properties.present?
        @event_id = event_properties['id']
        puts "Setting AttendeaseSDK.event_id as #{@event_id}"
      else
        puts "Error: Could not set AttendeaseSDK.event_id"
      end
    end

    def admin_headers
      {
        "Content-Type" => "application/json",
        "X-User-Token" => user_token,
      }
    end

    def event_headers
      headers = {}
      headers["Content-Type"] = "application/json"
      headers["X-Event-Token"] = event_token if event_token.present?
      headers
    end

    def admin_base_url
      case environment
      when 'preview'
        "https://dashboard.ci.attendease.com/"
      when 'prerelease'
        "https://dashboard.preview.attendease.com/"
      when 'development'
        "https://dashboard.localhost.attendease.com/"
      when 'production'
        "https://dashboard.attendease.com/"    
      end
    end

    def event_base_url
      case environment
      when 'preview'
        "https://#{AttendeaseSDK.event_subdomain}.ci.attendease.com/api/"
      when 'prerelease'
        "https://#{AttendeaseSDK.event_subdomain}.preview.attendease.com/api/"
      when 'development'
        "https://#{AttendeaseSDK.event_subdomain}.localhost.attendease.com/api/"
      when 'production'
        "https://#{AttendeaseSDK.event_subdomain}.attendease.com/api/"
      end
    end


    def organization_base_url
      case environment
      when 'preview'
        "https://#{AttendeaseSDK.subdomain}.ci.attendease.org/api/"
      when 'prerelease'
        "https://#{AttendeaseSDK.subdomain}.preview.attendease.org/api/"
      when 'development'
        "https://#{AttendeaseSDK.subdomain}.localhost.attendease.org/api/"
      when 'production'
        "https://#{AttendeaseSDK.subdomain}.attendease.org/api/"
      end
    end

  end

  class ConnectionError < RuntimeError
  end

  class DomainError < RuntimeError
  end

end

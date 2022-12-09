# frozen_string_literal: true

require 'httparty'
require 'json'

class MongoDBAtlasClient
  def initialize(base_url = nil, username = nil, password = nil)
    @base_url = base_url ||
                ENV['MONGODB_ATLAS_BASE_URL'] ||
                'https://cloud.mongodb.com/api/atlas/v1.0'
    @username = username ||
                ENV.fetch('MONGODB_ATLAS_PUBLIC_KEY', nil)
    @password = password ||
                ENV.fetch('MONGODB_ATLAS_PRIVATE_KEY', nil)
  end

  def get_all_private_endpoint_services_for_provider(project_id, provider)
    JSON.parse(
      get("/groups/#{project_id}/privateEndpoint/#{provider}/endpointService")
          .body
    )
  end

  def get_one_private_endpoint_for_provider(
    project_id,
    provider,
    endpoint_service_id,
    endpoint_id
  )
    project_url = "/groups/#{project_id}"
    endpoint_provider_url = "#{project_url}/privateEndpoint/#{provider}"
    endpoint_service_url =
      "#{endpoint_provider_url}/endpointService/#{endpoint_service_id}"
    endpoint_url = "#{endpoint_service_url}/endpoint/#{endpoint_id}"

    JSON.parse(get(endpoint_url).body)
  end

  private

  def get(path, headers = {})
    HTTParty.get(
      "#{@base_url}#{path}",
      default_headers.merge(headers)
    )
  end

  def default_headers
    {
      digest_auth: credentials
    }
  end

  def credentials
    {
      username: @username,
      password: @password
    }
  end
end

require "net/http"
require "uri"
require "json"

module HttpClient
  extend self

  def get(url, headers = [])
    uri = build_uri(url)
    request = build_request(:get, uri, headers)
    response = http_client(uri).request(request)

    handle_response(response)
  end

  private

  REQUEST_MAP = {
    get: Net::HTTP::Get,
    post: Net::HTTP::Post,
    put: Net::HTTP::Put,
    delete: Net::HTTP::Delete,
  }.freeze

  def build_uri(url)
    URI.parse(url)
  end

  def http_client(uri)
    Net::HTTP.new(uri.host, uri.port).tap do |http_client|
      http_client.use_ssl = true
    end
  end

  def build_request(request_type, uri, headers)
    REQUEST_MAP[request_type].new(uri.request_uri).tap do |request|
      headers.each { |k, v| request[k] = v }
    end
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      {"status" => "failure"}
    end
  end
end

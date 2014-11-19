require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module WalkscoreApi
  class Client
    BASE_URL = 'http://api.walkscore.com'

    def initialize
      @connection = Faraday.new(BASE_URL) do |faraday|
        faraday.adapter :typhoeus
      end
    end

    def make_connection(location, api_key)
      response = @connection.get do |req|
        req.url '/score'
        req.headers['Accepts'] = 'application/json'
        req.params['format'] = 'json'
        req.params['lat'] = location[:lat]
        req.params['lon'] = location[:long]
        req.params['wsapikey'] = api_key
      end
      response.body
    end

    def in_parallel(&block)
      @connection.in_parallel do
        block.call
      end
    end
  end
end
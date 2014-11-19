require 'json'

module WalkscoreApi
  class Walkscore
    attr_accessor :score, :description, :updated, :logo_url, :ws_link

    def initialize(attributes)
      self.score       = attributes['walkscore']
      self.description = attributes['description']
      self.updated     = attributes['updated']
      self.logo_url    = attributes['logo_url']
      self.ws_link     = attributes['ws_link']
    end

    def self.client
      WalkscoreApi::Client.new
    end

    def self.find(location, api_key)
      if location.kind_of?(Array)
        self.find_all(location, api_key)
      else
        parse_response(client.make_connection(location, api_key))
      end
    end

    def self.find_all(locations, api_key)
      responses = []
      client.in_parallel do
        responses = locations.map { |loc|
          client.make_connection(loc, api_key)
        }
      end
      responses.map { |resp|
        parse_response(resp)
      }
    end

    def self.parse_response(response)
      parsed_results = JSON.parse(response)
      WalkscoreApi::Walkscore.new(parsed_results)
    end
  end
end
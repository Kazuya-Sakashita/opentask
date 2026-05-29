require "net/http"
require "uri"
require "json"
require "jwt"

module Auth
  class SupabaseJwtVerifier
    JWKS_CACHE_KEY = "supabase:jwks".freeze
    JWKS_CACHE_EXPIRES_IN = 1.hour

    def initialize(token)
      @token = token
    end

    def call
      decoded_token = JWT.decode(
        token,
        nil,
        true,
        algorithms: supported_algorithms,
        jwks: jwks_loader
      )

      decoded_token.first
    rescue JWT::DecodeError, JWT::VerificationError, JWT::JWKError
      raise UnauthorizedError
    end

    private

    attr_reader :token

    def supported_algorithms
      %w[RS256 ES256]
    end

    def jwks_loader
      lambda do |options|
        @cached_jwks = nil if options[:invalidate]

        @cached_jwks ||= fetch_jwks
      end
    end

    def fetch_jwks
      Rails.cache.fetch(JWKS_CACHE_KEY, expires_in: JWKS_CACHE_EXPIRES_IN) do
        uri = URI.parse(ENV.fetch("SUPABASE_JWKS_URL"))
        response = Net::HTTP.get_response(uri)

        raise UnauthorizedError unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      end
    rescue KeyError, JSON::ParserError, URI::InvalidURIError
      raise UnauthorizedError
    end
  end
end

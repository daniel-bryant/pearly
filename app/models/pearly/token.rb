require 'jwt'

module Pearly
  class Token
    HMAC_SECRET = ENV.fetch("PEARLY_HMAC_SECRET", Rails.application.secret_key_base[0..31])
    ISSUER = ENV.fetch("PEARLY_ISSUER", "pearly")
    LIFESPAN = ENV.fetch("PEARLY_LIFESPAN", 1.day).to_i
    REFRESH_LIFESPAN = ENV.fetch("PEARLY_REFRESH_LIFESPAN", 7.days).to_i

    attr_reader :client_id, :user_id

    def initialize(client_id:, user_id:)
      @client_id = client_id
      @user_id = user_id
    end

    def access_token
      JWT.encode(access_token_payload, HMAC_SECRET, 'HS256')
    end

    def refresh_token
      JWT.encode(refresh_token_payload, HMAC_SECRET, 'HS256')
    end

    def token_type
      "bearer"
    end

    def expires_in
      LIFESPAN
    end

    def refresh_expires_in
      REFRESH_LIFESPAN
    end

    private

    def issued_at
      @issued_at ||= Time.current.to_i
    end

    def expires_at
      @expires_at ||= issued_at + expires_in
    end

    def refresh_expires_at
      @refresh_expires_at ||= issued_at + refresh_expires_in
    end

    def access_token_payload
      token_payload(exp: expires_at)
    end

    def refresh_token_payload
      token_payload(exp: refresh_expires_at)
    end

    def token_payload(exp:)
      {
        sub: user_id,
        iss: ISSUER,
        cid: client_id,
        iat: issued_at,
        exp: exp,
      }
    end
  end
end

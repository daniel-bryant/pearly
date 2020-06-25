require_dependency "pearly/application_controller"

module Pearly
  class TokensController < ApplicationController
    SUPPORTED_GRANT_TYPES = %w(password)

    before_action :validate_grant_type
    before_action :validate_params
    before_action :validate_client
    before_action :validate_grant

    def create
      render json: {
        access_token: @token.access_token,
        token_type: @token.token_type,
        expires_in: @token.expires_in,
        refresh_token: @token.refresh_token,
      }
    end

    private

    def validate_grant_type
      unless SUPPORTED_GRANT_TYPES.include? grant_type
        render json: { error: "unsupported_grant_type" }, status: 400
      end
    end

    def validate_params
      send("validate_#{grant_type}_params")
    end

    def validate_password_params
      if [client_id, client_secret, username, password].any?(&:blank?)
        render json: { error: "invalid_request" }, status: 400
      end
    end

    def validate_client
      unless Pearly.validate_client.call(client_id, client_secret)
        render json: { error: "invalid_client" }, status: 401
      end
    end

    def validate_grant
      send("authenticate_#{grant_type}")
    end

    def authenticate_password
      user = Pearly.authenticate.call(username, password)

      if user
        @token = Token.new(client_id: client_id, user_id: user.id)
      else
        render json: { error: "invalid_grant" }, status: 400
      end
    end

    def grant_type
      @grant_type ||= params[:grant_type]
    end

    def client_id
      @client_id ||= params[:client_id]
    end

    def client_secret
      @client_secret ||= params[:client_secret]
    end

    def username
      @username ||= params[:username]
    end

    def password
      @password ||= params[:password]
    end
  end
end

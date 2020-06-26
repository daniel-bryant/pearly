module Pearly
  module Authenticatable
    extend ActiveSupport::Concern
    include ActionController::HttpAuthentication::Token::ControllerMethods

    included do
      before_action :authenticate
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @current_token = Token.validate(token)
        current_user if current_token
      end
    end

    def current_token
      @current_token
    end

    def current_user
      @current_user ||= User.find(current_token.user_id)
    end
  end
end
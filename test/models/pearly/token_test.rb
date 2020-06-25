require 'test_helper'

module Pearly
  class TokenTest < ActiveSupport::TestCase
    setup do
      @token = Token.new(client_id: "test", user_id: 99)
    end

    test "#client_id" do
      assert_equal "test", @token.client_id
    end

    test "#user_id" do
      assert_equal 99, @token.user_id
    end

    test "#access_token" do
      freeze_time

      expected_token = JWT.encode({
        sub: 99,
        iss: "pearly",
        cid: "test",
        iat: Time.current.to_i,
        exp: Time.current.to_i + 1.day.to_i,
      }, Rails.application.secret_key_base[0..31], 'HS256')

      assert_equal expected_token, @token.access_token
    end

    test "#refresh_token" do
      freeze_time

      expected_token = JWT.encode({
        sub: 99,
        iss: "pearly",
        cid: "test",
        iat: Time.current.to_i,
        exp: Time.current.to_i + 7.days.to_i,
      }, Rails.application.secret_key_base[0..31], 'HS256')

      assert_equal expected_token, @token.refresh_token
    end

    test "#token_type" do
      assert_equal "bearer", @token.token_type
    end

    test "#expires_in" do
      assert_equal 1.day.to_i, @token.expires_in
    end

    test "#refresh_expires_in" do
      assert_equal 7.days.to_i, @token.refresh_expires_in
    end
  end
end

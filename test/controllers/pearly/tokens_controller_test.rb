require 'test_helper'
require 'jwt'

module Pearly
  class TokensControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes

      @grant_type = "password"
      @username = "jojo"
      @password = "prettyplease"
      @client_id = "sample client"
      @client_secret = "rubber ducks"
    end

    def token_params
      {
        grant_type: @grant_type,
        username: @username,
        password: @password,
        client_id: @client_id,
        client_secret: @client_secret,
      }
    end

    #
    # Creating a token
    # POST /tokens
    #

    # Failure scenarios
    test "should try create with invalid grant_type" do
      @grant_type = "invalid"

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "unsupported_grant_type" }.to_json, @response.body)
    end

    test "should try create with missing client_id" do
      @client_id = ""

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_request" }.to_json, @response.body)
    end

    test "should try create with missing client_secret" do
      @client_secret = ""

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_request" }.to_json, @response.body)
    end

    test "should try create with missing username" do
      @username = ""

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_request" }.to_json, @response.body)
    end

    test "should try create with missing password" do
      @password = ""

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_request" }.to_json, @response.body)
    end

    test "should try create with invalid client_id" do
      @client_id = "oops"

      post tokens_url, params: token_params

      assert_response :unauthorized
      assert_equal({ error: "invalid_client" }.to_json, @response.body)
    end

    test "should try create with invalid client_secret" do
      @client_secret = "angry birds"

      post tokens_url, params: token_params

      assert_response :unauthorized
      assert_equal({ error: "invalid_client" }.to_json, @response.body)
    end

    test "should try create with invalid username" do
      @username = "reverse flash"

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_grant" }.to_json, @response.body)
    end

    test "should try create with invalid password" do
      @password = "zoom"

      post tokens_url, params: token_params

      assert_response :bad_request
      assert_equal({ error: "invalid_grant" }.to_json, @response.body)
    end

    # Success scenarios
    test "should create a token" do
      freeze_time

      hmac_secret = Rails.application.secret_key_base[0..31]

      expected_access_token = JWT.encode({
        sub: "User.1",
        iss: "pearly",
        cid: "sample client",
        iat: Time.current.to_i,
        exp: Time.current.to_i + 1.day.to_i,
      }, hmac_secret, 'HS256')

      expected_refresh_token = JWT.encode({
        sub: "User.1",
        iss: "pearly",
        cid: "sample client",
        iat: Time.current.to_i,
        exp: Time.current.to_i + 7.days.to_i,
      }, hmac_secret, 'HS256')

      expected_response_body = {
        access_token: expected_access_token,
        token_type: "bearer",
        expires_in: 1.day.to_i,
        refresh_token: expected_refresh_token,
      }.to_json

      post tokens_url, params: token_params

      assert_response :success
      assert_equal(expected_response_body, @response.body)
    end
  end
end

require 'test_helper'

class AuthenticatableTest < ActionDispatch::IntegrationTest
  setup do
    @unauthorized_errors = [
      {
        "status" => "401",
        "detail" => "Unauthorized",
      }
    ]
  end

  test "should get rappers index without any authentication" do
    get rappers_url

    assert_response :unauthorized
    assert_equal(@unauthorized_errors, JSON.parse(@response.body))
  end

  test "should get rappers index without invalid authentication" do
    get rappers_url, headers: {
      "Authorization" => "Bearer invalid"
    }

    assert_response :unauthorized
    assert_equal(@unauthorized_errors, JSON.parse(@response.body))
  end

  test "should get rappers index" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: "User.1").access_token

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_equal([{ "name" => "Gunna" }], JSON.parse(@response.body))
  end

  test "should get rappers index with not found user" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: "User.2").access_token

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_response :unauthorized
    assert_equal(@unauthorized_errors, JSON.parse(@response.body))
  end

  test "should get rappers index with expired token" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: "User.1").access_token
    travel 1.day + 1.second

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_response :unauthorized
    assert_equal(@unauthorized_errors, JSON.parse(@response.body))
  end
end

require 'test_helper'

class AuthenticatableTest < ActionDispatch::IntegrationTest
  test "should get rappers index without any authentication" do
    get rappers_url

    assert_response :unauthorized
    assert_equal("HTTP Token: Access denied.\n", @response.body)
  end

  test "should get rappers index without invalid authentication" do
    get rappers_url, headers: {
      "Authorization" => "Bearer invalid"
    }

    assert_response :unauthorized
    assert_equal("HTTP Token: Access denied.\n", @response.body)
  end

  test "should get rappers index" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: 1).access_token

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_equal([{ name: "Gunna" }].to_json, @response.body)
  end

  test "should get rappers index with not found user" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: 2).access_token

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_response :unauthorized
    assert_equal("HTTP Token: Access denied.\n", @response.body)
  end

  test "should get rappers index with expired token" do
    access_token = Pearly::Token.new(client_id: "foo", user_id: 1).access_token
    travel 1.day + 1.second

    get rappers_url, headers: {
      "Authorization" => "Bearer #{access_token}"
    }

    assert_response :unauthorized
    assert_equal("HTTP Token: Access denied.\n", @response.body)
  end
end

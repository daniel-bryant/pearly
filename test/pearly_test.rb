require 'test_helper'

class Pearly::Test < ActiveSupport::TestCase
  setup do
    @cached_authenticate = Pearly.instance_variable_get(:@authenticate)
    @cached_validate_client = Pearly.instance_variable_get(:@validate_client)

    Pearly.instance_variable_set(:@authenticate, nil)
    Pearly.instance_variable_set(:@validate_client, nil)
  end

  teardown do
    Pearly.instance_variable_set(:@authenticate, @cached_authenticate)
    Pearly.instance_variable_set(:@validate_client, @cached_validate_client)
  end

  test "truth" do
    assert_kind_of Module, Pearly
  end

  test "should configure" do
    Pearly.configure do |config|
      assert_same Pearly, config
    end
  end

  test "should set and get authenticate" do
    my_proc = proc { |a, b| }
    Pearly.on_authenticate(&my_proc)
    assert_same my_proc, Pearly.authenticate
  end

  test "should set and get validate_client" do
    my_proc = proc { |a, b| }
    Pearly.on_validate_client(&my_proc)
    assert_same my_proc, Pearly.validate_client
  end

  test "should secure_validate" do
    assert_not Pearly.secure_validate("a", "b", {})
    assert_not Pearly.secure_validate("a", "b", {"x" => "b"})
    assert_not Pearly.secure_validate("a", "b", {"a" => "x"})

    assert Pearly.secure_validate("a", "b", {"a" => "b"})
  end
end

defmodule ESI.RequestFunctionsTest do
  use ExUnit.Case, async: true

  import ESI.RequestFunctions

  test "function name resources list" do
    path = "/killmails/"
    assert generate_function_name("get", path, false) == "get_killmails"
  end

  test "function name should remove version in path" do
    path = "/v1/killmails/"
    assert generate_function_name("get", path, true) == "get_killmails"
  end

  test "function name resource singleton" do
    path = "/killmails/{killmail_id}/"
    assert generate_function_name("get", path, false) == "get_killmail"
  end

  test "function name should only condense arguments" do
    path = "/killmails/killmail_id/"
    assert generate_function_name("get", path, false) == "get_killmails_killmail_id"
  end

  test "function name should only condense _id arguments" do
    path = "/killmails/{killmail_id}/{killmail_hash}/"
    assert generate_function_name("get", path, false) == "get_killmail_killmail_hash"
  end
end

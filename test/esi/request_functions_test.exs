defmodule ESI.RequestFunctionsTest do
  use ExUnit.Case, async: true

  import ESI.RequestFunctions

  test "function name resources list" do
    func_name = generate_function_name(
      "get",
      ["killmails"]
    )
    assert "get_killmails" == func_name
  end

  test "function name resource singleton" do
    func_name = generate_function_name(
      "get",
      ["killmails", "{killmail_id}"]
    )
    assert "get_killmail" == func_name
  end

  test "function name should only condense arguments" do
    func_name = generate_function_name(
      "get",
      ["killmails", "killmail_id"]
    )
    assert "get_killmails_killmail_id" == func_name
  end

  test "function name should only condense _id arguments" do
    func_name = generate_function_name(
      "get",
      ["killmails", "{killmail_id}", "{killmail_hash}"]
    )
    assert "get_killmail_killmail_hash" == func_name
  end
end
